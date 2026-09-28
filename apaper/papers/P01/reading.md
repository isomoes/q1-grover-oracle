# P01 / G01 — A fast quantum mechanical algorithm for database search

## 阅读目标与上下文

- 状态：reading。承接 [2026-09-15 笔记](note.md)，理解通用 Grover 搜索如何约束 AES 完整相位 oracle。
- 当前主读：[S01，STOC 1996 会议版](sources/grover-stoc-1996.pdf)，来自用户指定的 issue #1。版本与检查范围见下方[来源清单](#sources)；论文身份与路线见[共享论文记录](../../landscape/papers.json)的 P01 条目。
- 对照：[S02，arXiv v3，1996-11-19](sources/grover-arxiv-v3.pdf)，这是旧笔记引用的更新稿。两个版本页码和证明组织不能混用。
- 暂以读者已接触振幅、相位标记和 diffusion 记号为起点；本轮尚无用户复述或理解确认。

## 进度

| 单元 / 原文定位 | 已核对或解释 | 剩余问题 |
|---|---|---|
| S01 首页、§1–4，印刷 pp. 212–215；S05 Comments | 附件为会议版；arXiv v3 明确为更新稿 | 未逐步审计会议版 §5 的证明 |
| S01 §2–3，印刷 p. 214 / PDF 第 3 页 | 唯一解、单位成本判断、相位标记后 diffusion；测量成功率表述为至少 1/2 | 合适迭代数的证明留待续读 |
| S02 §3 末段，p. 3 | 标记后不留下状态痕迹，以便路径干涉；不作经典测量 | 具体 AES 清理电路需读 P02/P03 |
| S02 §4，p. 4 | D = −I + 2P，P 的每个元素为 1/N，得到关于平均振幅的反射 | 本次主讲清理接口，未展开完整收敛证明 |
| 助手重构，链接见下 | 用 U† Z U 解释计算—标记—反计算，以及反计算保留相位的原因 | 无真实 AES 电路执行或资源复现 |

## 当前工作理解

1. **原文支持：** S01 §3(ii)(a) 定义的是对搜索态的条件相位变换。S02 §3 末段补充实现要求：外部系统不能留下区分搜索分支的状态痕迹。这里“不留下痕迹”不指删除搜索寄存器中的候选标签。
2. **助手重构：** 若 U 将 `|K>|0>|0>` 映射成 `|K>|g(K)>|f(K)>`，则先 U、再对判断位施加 Z、最后 U†，得到 `(-1)^f(K)|K>|0>|0>`。U† 撤销寄存器内容，但线性性使相位因子保留下来。推导和四候选反例见 [反计算推导](cleanup-derivation.md)。
3. **适用边界：** 对本项目“只在密钥寄存器上做 diffusion”的接口，候选相关的垃圾一般破坏预期干涉；仅仅不测量并不充分。抽象上辅助系统最终是同一个、与 K 无关的状态即可；全零是项目选定的可复用接口。不能据此声称一切振幅放大构造都必须使用同一种清理方法。
4. **版本区别：** 旧笔记 §3.4 的“不留下状态痕迹”和平均振幅解释有 S02 支持；它不是会议版 §3 的逐字转述。旧笔记的多解二维旋转公式属于补充模型，本轮没有把它认作会议版中的直接公式。
5. **项目应用：** AES 的轮状态、临时轮密钥和比较位属于 U 的工作空间；计算、标记、清理、diffusion 的成本边界来自 S04。Grover 的单位成本假设不提供这些实际资源数。

## 开放问题

- **Q01（已定位）** issue 附件与旧笔记所引是否同一版本？否，分别为 STOC 1996 和 arXiv v3；算法相同，证明组织不同，见 S01 首页及 S05 Comments。
- **Q02（已给出重构，理解待确认）** 为什么未测量的垃圾也可能妨碍密钥寄存器上的 diffusion？见 S02 §3 末段及工作推导中的正交标签例子。
- **Q03（已给出重构，理解待确认）** 为什么 U† 不把目标相位也撤销？线性性；逆掉 U 而非整个 ZU。
- **Q04（待续读）** 将旧笔记 N=4 例子分别扩展为“已清理”和“保留候选相关垃圾”时，一轮后的目标概率如何不同？工作推导已给出助手计算，下一轮可展开解释。
- **Q05（待选读）** 会议版 §4 Theorem 4 与 §5 对应证明怎样建立 O(√N) 轮数？若改读更新稿，则另定位其 §4–5，不混用定理编号。
- **Q06（后续 P02/P03）** 明密文对数量、额外匹配密钥、比较和清理如何进入 AES 完整 oracle 资源估算？沿用旧笔记 §6 的五个问题。

## 下一步

优先接着 Q04，用旧笔记的四候选例子比较干净工作空间与 `|g(K)>=|K>` 正交标签情形，解释为什么后者即使不测量，一次密钥 diffusion 后目标概率仍为 1/4，而前者为 1。然后按用户问题继续收敛证明或 P02 的可逆 AES 构造。

## 会话检查点

- **2026-09-28：** 读取旧笔记和项目模型；下载并区分会议版与 arXiv v3，保留提取文本和两版第 3 页图像；检查上述选定段落。首个讲解单元为“无状态痕迹 → 计算—标记—反计算”，未声称完整通读、用户已掌握或 AES 电路复现。自动保留阅读进度；随后按用户要求将既有笔记从 docs 移入 [note.md](note.md)，保留正文并修复相对链接。

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
