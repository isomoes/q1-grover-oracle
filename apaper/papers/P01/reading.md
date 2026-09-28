# P01 / G01 — A fast quantum mechanical algorithm for database search

## 这篇文章做了什么

本文提出无结构搜索的量子算法：在唯一目标、条件判断按单位成本计算的模型下，通过条件相位标记和扩散，以 O(√N) 次查询达到常数成功概率。它给出通用搜索框架及分析，不提供 AES 的具体判定电路或门级资源估计。（S01，Summary、§2–4）

- 当前主读：[S01，STOC 1996 会议版](sources/grover-stoc-1996.pdf)，来自用户指定的 issue #1。版本与检查范围见下方[来源清单](#sources)；论文身份与路线见[共享论文记录](../../landscape/papers.json)的 P01 条目。
- 对照：[S02，arXiv v3，1996-11-19](sources/grover-arxiv-v3.pdf)，这是旧笔记引用的更新稿。两个版本页码和证明组织不能混用。

## 读者提出的问题

当前记录中，没有可确认为读者本轮提出或采纳的具体技术问题。旧笔记中的讨论保留在原文件；此前由助手列出的 Q01–Q06 及四候选清理例子的续读安排已撤下，编号退役，不作为当前问题清单。

## 选定笔记

- [2026-09-15 既有笔记](note.md)：按读者此前要求迁入本目录，保留原正文和版本核对。旧笔记的阅读建议属于历史内容，不自动决定当前方向。

## 协作约定与历史材料

- 2026-09-28：按读者要求调整为协作式阅读，由读者提问，助手解释并记录选定内容；撤下助手安排的问题和下一步。
- [反计算推导](cleanup-derivation.md)是此前助手生成的推导材料，保留供查阅，不是读者选定笔记或当前阅读任务。
- 已核对的版本区别：S01 为会议版，S02 为更新稿；旧笔记中“不留下状态痕迹”的表述对应 S02 §3 末段，不能混作 S01 的逐字引文。所查章节见下方来源记录。

<a id="sources"></a>
## 来源清单与检查范围

以下来源均于 2026-09-28 检查；S01 为当前主读来源。`full_text` 仅表示检查过列出的正文段落，不表示完整通读。未记录代码运行或实验复现。

<a id="s01"></a>
### S01 — A fast quantum mechanical algorithm for database search

- 角色：`target`；访问：`local`；检查层级：`full_text`。
- 来源：[issue 附件](https://github.com/user-attachments/files/32083169/237814.237866.pdf)；本地：[会议版 PDF](sources/grover-stoc-1996.pdf)。
- 版本：STOC 1996, pp. 212–219；精确版本日期未知。
- 已检查：Title, Summary and sections 1–4, printed pp. 212–215; section 3 equations visually checked on printed p. 214 (viewer p. 3)
- 用途：用户指定的 issue 附件；当前主读版本。
- SHA256：`158635c3ebeffc019b4e637f55f991d3f691f5e78614b4e25aeb878246e50e88`。
- 备注：来自 issue #1 第一个附件。第 5 节详细证明尚未逐步核验。PDF 元数据的 1997 制作日期不当作论文发表日期。

<a id="s02"></a>
### S02 — A fast quantum mechanical algorithm for database search — updated version

- 角色：`target`；访问：`local`；检查层级：`full_text`。
- 来源：[arXiv PDF](https://arxiv.org/pdf/quant-ph/9605043v3)；本地：[更新稿 PDF](sources/grover-arxiv-v3.pdf)。
- 版本：arXiv quant-ph/9605043v3；版本日期：1996-11-19。
- 已检查：
  - Title, Summary and sections 1–3, pp. 1–3
  - Section 3 closing paragraph on no residual state trace, p. 3, visually checked
  - Section 4 inversion-about-average explanation and algebra, p. 4
- 用途：对照旧笔记引用的更新稿，定位不留下状态痕迹的原文。
- 备注：与 S01 算法相同，证明组织不同；未审计完整收敛证明。渲染中部分数学字形异常，标记和 diffusion 定义另与 S01 页面核对；第 3 节末尾英文段落可读。

<a id="s03"></a>
### S03 — Grover 原论文阅读笔记：从无结构搜索到密钥搜索 oracle

- 角色：`explanation`；访问：`local`；检查层级：`full_text`。
- 本地来源：[既有笔记](note.md)；无外部 URL。
- 版本：2026-09-15 notes; 2026-09-28 version/navigation addendum；未单独记录版本日期。
- 已检查：Sections 1–6
- 用途：用户提供的既有理解、记号及后续问题；作为续读上下文。
- 备注：不把既有理解陈述当作本轮已验证的用户掌握程度。

<a id="s04"></a>
### S04 — Research plan: Q1 Grover oracle circuits

- 角色：`explanation`；访问：`local`；检查层级：`full_text`。
- 本地来源：[研究计划](../../../docs/research-plan.md)；无外部 URL；版本与版本日期未记录。
- 已检查：
  - Model and oracle contract
  - Initial implementation scope
  - Baselines and proposed experiments
  - Resource accounting
  - Completion criteria for the first research result
- 用途：AES 谓词、Q1 访问模型、全零工作空间和成本边界的项目设定。
- 备注：项目模型，不归因于 Grover 1996 的 AES 实现结果。

<a id="s05"></a>
### S05 — arXiv quant-ph/9605043v3 metadata and submission history

- 角色：`target`；访问：`remote`；检查层级：`abstract`。
- 来源：[arXiv 记录](https://arxiv.org/abs/quant-ph/9605043v3)；无本地副本。
- 版本：arXiv v3 metadata；版本日期：1996-11-19。
- 已检查：Title, author, abstract, Comments and submission history
- 用途：核验更新稿日期和作者说明：算法相同，采用 inversion about average 简化证明。

<a id="s06"></a>
### S06 — Reference Paper PDF — repository issue #1

- 角色：`explanation`；访问：`remote`；检查层级：`metadata`。
- 来源：[issue #1](https://github.com/isomoes/q1-grover-oracle/issues/1)；无本地副本；版本与版本日期未记录。
- 已检查：Issue body attachment links; comments response empty
- 用途：解析用户指定的 Grover PDF 附件来源。
