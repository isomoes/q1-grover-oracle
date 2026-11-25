# 稿件证据快照 · 2026-11-25

**范围：** [稿件](../../tex/index.tex) 的背景比较与技术概述候选表述。此版本只有章节骨架，以下均未写入正文。稿件和本地证据使用同一 Git 版本 `11b4c0ffc95ae92c8b0f260cf0a17c17116ee884`；下列链接用于导航，冻结内容可用 `git show <版本>:<仓库相对路径>` 读取。

| ID · 拟用章节 | 候选表述 | 证据及适用边界 |
|---|---|---|
| C01 · Introduction | P22 报告其 AES-128 加密电路的一个配置宽度为 1,028，T-depth 为 100。 | **作者报告。** P22，[arXiv v2，§IV、Table XIV](https://arxiv.org/html/2503.06097v2)，`c₂²–c₃³` 配置；含密钥扩展，不是完整相位 oracle。版本核对及转录见 [`apaper/synthesis/route-assessment-2026-11-11.md`](../synthesis/route-assessment-2026-11-11.md) §2.3。 |
| C02 · Technical Overview | 在旧首字、新首字和待清理的 32 位字分别仍在三个寄存器中的例子里，全连接下可用两层共 64 个 CNOT 清零该中间字，无需额外辅助位。 | **本地推导。** [`apaper/synthesis/algebra-aware-cleanup-2026-11-23.md`](../synthesis/algebra-aware-cleanup-2026-11-23.md) “一个能直接落实为门的例子”。[FIPS 197-upd1](../sources/fips-197-upd1.pdf) §5.2 算法 2 仅支持输入递推；门数来自本地推导，假定不相交门可并行，不含 S-box 工作位清理。 |
| C03 · Resource Evaluation | 相同峰值宽度下，这种清理许可是否缩短完整迭代的全深度？ | **开放问题。** 同一推导文件“第一个判别实验”列出判据，但没有匹配的完整迭代结果。在取得可定位的运行记录和代码版本前只能作为问题。 |
