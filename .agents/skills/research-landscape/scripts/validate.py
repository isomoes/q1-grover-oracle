#!/usr/bin/env python3
"""Validate research-landscape structure, not scientific truth. Stdlib only."""

import argparse
import json
import re
import sys
from pathlib import Path


def validate(root):
    errors = []
    required = (
        "report.md",
        "graph.mmd",
        "papers.json",
        "references.bib",
        "search-log.md",
    )
    for name in required:
        if not (root / name).is_file() or not (root / name).stat().st_size:
            errors.append(f"Missing or empty file: {name}")
    if errors:
        return errors
    try:
        data = json.loads((root / "papers.json").read_text())
    except (ValueError, OSError) as exc:
        return [f"Invalid papers.json: {exc}"]
    if not isinstance(data, dict):
        return ["papers.json must contain an object"]
    for key in (
        "topic",
        "searched_on",
        "cutoff_date",
        "coverage",
        "papers",
        "routes",
        "edges",
        "comparisons",
    ):
        if key not in data:
            errors.append(f"Missing top-level field: {key}")
    for field in ("papers", "routes", "edges", "comparisons"):
        value = data.get(field)
        if not isinstance(value, list) or any(not isinstance(x, dict) for x in value):
            return errors + [f"{field} must be an array of objects"]
    papers, routes = data["papers"], data["routes"]
    pids = [p.get("id") for p in papers]
    rids = [r.get("id") for r in routes]
    for label, ids in (("paper", pids), ("route", rids)):
        if not ids or any(not isinstance(x, str) or not x for x in ids):
            return errors + [f"Invalid or empty {label} IDs"]
        if len(set(ids)) != len(ids):
            errors.append(f"Duplicate {label} IDs")

    def refs(ids, allowed, where):
        if not isinstance(ids, list) or any(
            not isinstance(x, str) or x not in allowed for x in ids
        ):
            errors.append(f"Invalid references in {where}: {ids}")

    def evidence(items, where, required=False):
        if not isinstance(items, list) or (required and not items):
            errors.append(f"Missing evidence: {where}")
            return
        for item in items:
            if not isinstance(item, dict) or any(
                not item.get(k) for k in ("claim", "url", "locator", "support")
            ):
                errors.append(f"Incomplete evidence: {where}")

    bib = (root / "references.bib").read_text()
    bibkeys = re.findall(r"@\w+\s*\{\s*([^,\s]+)\s*,", bib)
    if len(bibkeys) != len(set(bibkeys)):
        errors.append("Duplicate BibTeX keys")
    keys = []
    for p in papers:
        pid = p["id"]
        for k in (
            "title",
            "authors",
            "year",
            "publication_status",
            "urls",
            "bibtex_key",
            "roles",
            "versions",
            "selection_reason",
        ):
            if k not in p or p[k] in (None, "", []):
                errors.append(f"{pid}: missing {k}")
        if p.get("read_level") not in ("metadata", "abstract", "full_text"):
            errors.append(f"{pid}: invalid read_level")
        refs(p.get("routes"), rids, pid)
        evidence(p.get("evidence"), pid, required=True)
        key = p.get("bibtex_key")
        if key not in bibkeys:
            errors.append(f"{pid}: BibTeX key missing: {key}")
        keys.append(key)
    if len(keys) != len(set(keys)):
        errors.append(
            "Multiple paper nodes share a BibTeX key; check duplicate versions"
        )
    for r in routes:
        for k in ("foundation_ids", "milestone_ids", "recent_ids"):
            refs(r.get(k), pids, f"{r['id']}.{k}")
        leaders = r.get("leaders")
        if not isinstance(leaders, list) or not leaders:
            errors.append(f"{r['id']}: missing leader assessment")
            continue
        for leader in leaders:
            if not isinstance(leader, dict):
                errors.append(f"{r['id']}: invalid leader object")
                continue
            refs(leader.get("paper_ids"), pids, r["id"])
            if leader.get("status") not in ("supported", "candidate", "undetermined"):
                errors.append(f"{r['id']}: invalid leader status")
            for k in ("criterion", "conditions", "reason"):
                if not leader.get(k):
                    errors.append(f"{r['id']}: leader missing {k}")
            evidence(
                leader.get("evidence"), r["id"], leader.get("status") == "supported"
            )
    for edge in data["edges"]:
        refs([edge.get("source"), edge.get("target")], pids, "edge")
        kind = edge.get("type")
        if kind not in ("extends", "uses", "improves", "compares", "related"):
            errors.append(f"Invalid edge type: {kind}")
        if edge.get("basis") != ("analyst" if kind == "related" else "documented"):
            errors.append(f"Invalid evidence basis: {edge}")
        evidence(
            edge.get("evidence"),
            f"edge {edge.get('source')}->{edge.get('target')}",
            kind != "related",
        )
    for c in data["comparisons"]:
        refs([c.get("route_id")], rids, "comparison.route_id")
        refs(c.get("paper_ids"), pids, "comparison.paper_ids")
    graph = (root / "graph.mmd").read_text().strip()
    report = (root / "report.md").read_text()
    if graph not in report:
        errors.append("report.md does not embed the exact graph.mmd content")
    for pid in pids:
        if pid not in report:
            errors.append(f"{pid} not found in report.md")
    return errors


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output_dir", type=Path)
    args = parser.parse_args()
    problems = validate(args.output_dir)
    for problem in problems:
        print(f"ERROR: {problem}")
    if not problems:
        print(
            "PASS: structural checks only; verify source evidence and scientific conclusions separately."
        )
    sys.exit(bool(problems))
