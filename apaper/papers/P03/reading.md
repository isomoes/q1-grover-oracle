# P03 — Implementing Grover oracles for quantum key search on AES and LowMC

## What the paper does

The paper studies quantum key search under a circuit-depth restriction, designs lower-depth AES and LowMC circuits, and provides Q# implementations of their full Grover oracles with automated resource estimates. The authors report lower attack costs in gate-count and depth-times-width models. This summary is supported by S01's abstract; it is not an independent reproduction.

Shared identity: [P03 / G03 in the registry](../../landscape/papers.json), citation key `JaquesNRV2020Grover`; [landscape entry](../../landscape/report.md). The reading session uses the corrected ePrint dated **2023-06-07**, associated with the EUROCRYPT 2020 paper. Active full-text source: **S02**, the [locally retained corrected paper](../../sources/iacr_2019_1146_corrected_2023-06-07.pdf); contribution summary checked using S01. The correction revises AES estimates for Q# issues; LowMC estimates were not revised.

## Reader's questions

On 2026-09-28, the reader selected P03 for this reading session.

### Q01 — How do the formulas and symbols in §2.1 relate to P01?

- Raised 2026-10-09: the reader asks for a notation/formula correspondence, rather than a different algorithm.
- Answered by source comparison and assistant algebra: P03's k corresponds to P01's n, x to a state label S, f(x) to C(S), and the uniform state ψ to P01's initial amplitude vector. P01's single-qubit matrix M is the Hadamard gate; P03's M instead counts solutions (P01 assumes one). P03's extra qubit φ = (|0⟩ − |1⟩)/√2 converts the XOR oracle U_f into P01's conditional phase flip by phase kickback; it remains factored out and unchanged. With O_f denoting the induced phase oracle on the search register, P03's iteration reduces to D O_f. The diffusion acts only on the search register (an identity on the extra qubit is implicit).
- Diffusion equivalence (assistant algebra from the checked definitions):

$$
D=2|\psi\rangle\langle\psi|-I,\qquad D_{ij}=\frac{2}{N}-\delta_{ij}.
$$

- P01's factorization D = F R F corresponds to F = H⊗k and R = 2|0ᵏ⟩⟨0ᵏ| − I, with F|0ᵏ⟩ = |ψ⟩. Thus the matrix, factorization, and projector expressions describe the same operator. P03's p(j) = sin²((2j + 1)θ), with sin²θ = M/N, includes multiple solutions and cites BBHT98; it is not a mere renaming of P01's unique-solution statement. The first peak occurs near j = π/(4θ) − 1/2; the square-root iteration estimate assumes M ≪ N.
- Evidence: P03/S02, corrected 2023-06-07 ePrint, §2.1, printed/viewer p. 4; supporting P03/S03 (= P01/S01), STOC 1996, §§2–3, printed p. 214 / viewer p. 3. Both pages visually checked on 2026-10-09. The correspondence does not audit P03's optimality or rounded-iteration probability-bound claims.

### Q02 — What does rotation in the plane spanned by two orthogonal vectors mean?

- Raised 2026-10-09: the reader asks about the geometric explanation of each Grover iteration in §2.1.
- Answer: for 0 < M < N, define |g⟩ as the normalized uniform superposition of solution indices and |b⟩ as that of non-solution indices. They are orthogonal because their computational-basis supports are disjoint. Uniform initialization and the oracle/diffusion symmetry keep the state inside their two-dimensional span, despite the full search space having dimension N. This is a plane of quantum-state vectors, not physical space. The initial state has coefficients cos θ on |b⟩ and sin θ on |g⟩, with sin²θ = M/N. Phase marking reflects the good component's sign; diffusion reflects about the fixed initial-state direction |ψ⟩. Their composition rotates by 2θ per iteration.
- Assistant reconstruction of the source's geometric statement:

$$
|\psi_j\rangle=\cos((2j+1)\theta)|b\rangle+\sin((2j+1)\theta)|g\rangle.
$$

- Thus the total solution probability is sin²((2j + 1)θ). Rotations continue past the solution direction, so additional iterations eventually lower success probability; “towards” describes the useful amplification stage, not monotonic improvement forever. At M = N the non-solution vector is undefined and every candidate already succeeds; M = 0 has no solution vector and lies outside §2.1's stated M ≥ 1 range.
- Evidence: P03/S02, corrected 2023-06-07 ePrint, §2.1, printed/viewer p. 4 (already visually inspected). Definitions of |g⟩, |b⟩ and the two-reflection algebra are assistant derivations from the checked oracle/diffusion definitions, not quoted equations from the paper. No new source inspection or full-proof audit.

### Q03 — Why does the extra-qubit state φ negate the good component?

- Raised 2026-10-09: the reader asks why preparing φ causes the solution component's sign to change.
- Answer: φ does not negate anything by itself. U_f applies X to the extra qubit only on branches with f(x) = 1. Since φ = (|0⟩ − |1⟩)/√2 is an eigenvector of X with eigenvalue −1, those branches acquire a minus sign; f(x) = 0 branches acquire none. The extra qubit factors out unchanged, leaving a relative phase between the good and bad search components.
- Assistant algebra, with |b⟩ and |g⟩ as in Q02:

$$
U_f\bigl[(\beta|b\rangle+\alpha|g\rangle)\otimes|\varphi\rangle\bigr]=(\beta|b\rangle-\alpha|g\rangle)\otimes|\varphi\rangle.
$$

- A minus sign on an isolated branch can be viewed as a global phase of that branch considered alone; within the full superposition it is a relative phase, not an unobservable global sign on the entire state. The operation does not immediately change measurement probabilities; diffusion subsequently converts the phase difference into amplitude changes.
- Evidence: P03/S02, corrected 2023-06-07 ePrint, §2.1, first paragraph, printed/viewer p. 4. The controlled-X action and phase-oracle identity are stated in the paper; the grouped-superposition equation is an assistant derivation. No new source coverage.

### Q04 — What is the “Repeated measurements” paragraph discussing?

- Raised 2026-10-10: the reader asks for the meaning of §2.2's paragraph.
- Answer: compare one uninterrupted Grover run with early stopping, measurement of the search register, classical candidate verification, and fresh initialization/restart on failure. This is not repeatedly measuring the unchanged final state or measuring after every oracle gate. Independent runs of j iterations succeed with probability p(j); the expected number of runs until success is 1/p(j), giving j/p(j) expected Grover iterations (not a complete gate-cost accounting of initialization/verification).
- P03 reports, citing BBHT98, that stopping at about 0.583√(N/M) iterations minimizes this expected iteration count to about 0.690√(N/M), versus approximately (π/4)√(N/M) for a run near the first success peak. These are small-M/N approximations. If the first short run fails, two runs already consume 1.166√(N/M) iterations, exceeding the near-peak run's approximately 0.785√(N/M).
- The central distinction is expected work versus high success probability within a hard total-depth budget. With at most m independent runs, success probability is 1 − (1 − p(j))ᵐ; a single coherent run of mj iterations has p(mj). P03 favors uninterrupted iterations under its pre-peak angle condition and large-j approximation; this is not a universal rule after overshooting the peak or for unknown solution counts. Verification of a marked solution does not by itself establish that it is the original secret key when spurious keys exist.
- Evidence: P03/S02, corrected 2023-06-07 ePrint, §2.2, “Depth constraints for cryptanalysis” and “Repeated measurements,” printed/viewer p. 6, text and rendered formulas inspected 2026-10-10. BBHT98 itself was not newly consulted. The geometric waiting-time explanation is an assistant derivation from independent restarts.

### Q05 — If diffusion increases the candidate amplitude, why can a shorter run fail?

- Raised 2026-10-10: the reader connects diffusion with amplitude growth and asks why using fewer iterations can lead to no success.
- Clarification: fewer iterations do not imply certain failure. Before the first peak, they generally give a lower solution probability; measurement may still select a non-solution. A full oracle-plus-diffusion iteration amplifies the solution component without making it immediately certain. Diffusion alone has no knowledge of the predicate, and amplification is not monotonic after the peak.
- Assistant-constructed example: N = 16, M = 1. Initially each amplitude is 1/4. After marking, the target amplitude is −1/4 and each of the other 15 is 1/4; the mean is 7/32. Diffusion changes the target amplitude to 11/16 and each non-target amplitude to 3/16. Thus target success probability after one iteration is 121/256 ≈ 47.27%, versus 1/16 = 6.25% initially; the remaining 135/256 ≈ 52.73% is spread across non-solutions. Strong amplification can coexist with substantial failure probability. A failed early measurement cannot preserve the earlier amplified superposition for the fresh-restart strategy in Q04.
- Evidence: P03/S02, corrected 2023-06-07 ePrint, §2.1, p. 4 (oracle, diffusion, and p(j)); §2.2, “Repeated measurements,” p. 6. The N = 16 calculation is an assistant algebraic example, not a paper experiment. No new source coverage.

### Q06 — 解数 M 已知时，是否迭代越多越好，候选密钥振幅会收敛到 1？

- 提问日期：2026-10-10。读者询问：已知满足条件的密钥数 M，是否意味着不断迭代会使候选密钥振幅收敛到 1。
- 回答：不会。标准 Grover 迭代是两个反射合成的幺正旋转，每轮旋转 2θ；已知 M 可以帮助选择停止轮数，但不会使状态停在解方向。解空间分量的振幅为 sin((2j + 1)θ)，总成功率为其平方，随轮数振荡而非收敛；达到或接近首次峰值之后，继续迭代可能降低成功率。整数轮数限制意味着峰值不一定恰好达到 1。
- 当存在 M 个解、且采用均匀初始化与标准 oracle/diffusion 时，每个匹配密钥的振幅为 sin((2j + 1)θ)/√M，测得某个指定匹配密钥的概率为 p(j)/M。因此，“解空间总成功率接近 1”不等于“每个候选的振幅接近 1”，也不等于必然恢复原始秘密密钥。
- 助手构造的精确例子：N = 4，M = 1，θ = π/6。j = 0、1、2、3、4 时成功率依次为 1/4、1、1/4、1/4、1。一次迭代已经成功率为 1，但继续一次会降回 1/4，直接否定单调收敛的理解。
- 来源：P03/S02，2023-06-07 修正版，§2.1，第 4 页，二维旋转与 p(j) 公式；§2.2 第 4 页，伪匹配密钥的等概率说明。单个密钥振幅和四候选例子为助手从已核对公式作出的代数推导。没有新增来源检查；未把固定点搜索等修改算法混入标准 Grover。

### Q07 — 每轮偏转角是否与伪匹配密钥数量有关，M 越多 θ 是否越小？

- 提问日期：2026-10-10。读者询问 spurious keys 的数量对旋转角的影响，并提出 M 越多 θ 越小的猜想。
- 回答：有关，但在搜索空间大小 N 固定时方向相反：θ = arcsin√(M/N)，所以 M 越大，θ 越大，每轮实际旋转角 2θ 也越大。θ 是初始状态与非解方向的夹角，不是每轮旋转角。若有 S 个伪匹配密钥且原始密钥满足判定条件，则总解数 M = S + 1。
- 解释：匹配密钥越多，均匀初态已经落在解空间的概率 M/N 越大，因此初始状态更靠近解方向。在 M ≪ N 的范围内，找到任一匹配密钥的近峰值轮数约为 (π/4)√(N/M)，随 M 增大而减小；但这不等于更容易找到原始秘密密钥。在标准对称搜索中，指定原始密钥的测量概率为 p(j)/M。
- 来源：P03/S02，2023-06-07 修正版，§2.1，第 4 页，sin²θ = M/N 与旋转描述；§2.2，第 4 页，M − 1 个伪匹配密钥及各匹配密钥等概率的说明。角度单调性及指定密钥概率为助手代数解释；无新增来源检查。

### Q08 — 满足判定条件的密钥数量 M 增大，还会影响 Grover 的哪些方面？

- 提问日期：2026-10-10。读者要求扩展理解 M 对算法的影响。
- 回答范围：固定搜索空间大小 N、固定判定条件、理想均匀初始化下，M/N 决定初始匹配概率、旋转角与完整成功率曲线。M 越大则初始匹配概率越高、旋转角 2θ 越大；在已知 M 且 M ≪ N 时，找到任意解的首次峰值轮数约为 (π/4)√(N/M)，查询复杂度为 O(√(N/M))。更大角度也意味着更快越过峰值，应按 M 选择停止轮数，不能固定沿用唯一解轮数或假定峰值随 M 单调变化。
- 各匹配密钥等概率，指定密钥的概率为 p(j)/M；总匹配成功率高不等于原始密钥恢复成功率高。若伪匹配数量未知，θ 与合适轮数也未知；P03 在 §2.2 Remark 2 提及调整搜索或先做量子计数，未在本次解释中审计这些算法。
- M 本身不会使固定 N 所需的搜索寄存器缩小，也不能单独决定单次 oracle 的门数或深度。总搜索门数可在明确成本边界后理解为迭代次数乘以单轮成本，并额外计入初始化/测量/验证；减少判定用的明密文对可能同时增加伪匹配并改变 oracle 成本，但这是另一个条件变化，不能由 M 单独推断。
- 来源：P03/S02，2023-06-07 修正版，§2.1 第 4 页（初始化、概率、轮数），§2.2 第 4 页（匹配密钥等概率），§2.2 Remark 2 第 7 页（未知伪匹配数量，已读取现有提取文本）。变化方向、寄存器大小及成本边界说明为助手从公式和算法接口作出的解释；未新增实验或未知解数算法验证。

### Q09 — P03 在哪里使用 inner parallelization？

- 提问日期：2026-10-10。读者询问论文实际使用内并行的位置。
- 回答：§2.3（第 7–8 页）定义并说明把密钥空间划成 S 个互不相交子集的优势；§3.5（第 14 页），式 (5)–(10)，将其用于机器数量、深度、总门数和深度乘宽度的成本推导；§6 开头（第 26 页）明确说明使用搜索空间划分；§6.2 的 “Cost estimates under a depth limit”（第 29 页）将其用于 AES/LowMC 的 MAXDEPTH 约束估算，具体结果在 Table 14（AES，第 32–33 页）和 Table 15（LowMC，第 34 页）。这里是完整攻击策略与资源估计层面的使用，不是已经运行庞大多机密钥恢复的实验证据。
- 区别：Figure 8 中同一个候选密钥下 r 个明文加密的并行属于 oracle 内部电路并行，不是 inner parallelization 所指的密钥空间划分。§3.5 本身也区分降低 oracle 深度的电路并行与增加搜索机器数的并行。
- 关联：§2.3 式 (4) 估计目标密钥所在子集的伪匹配概率；划分可能减少 oracle 所需的明密文对 r，其他子集测出的伪匹配用额外明密文对经典验证。不是确定消灭全局伪匹配，也不保证原始密钥所在子集没有伪匹配。Table 14/15 的 S 列表示密钥子集数量，r 表示 oracle 使用的明密文对数，SKP 表示目标子集出现伪匹配的概率。
- 来源：P03/S02，2023-06-07 修正版；本次读取 §2.3、§3.5 成本推导、§6 开头与 §6.1 相关段落、§6.2 深度限制说明和 Table 14/15 标题与解释的现有 PDF 提取文本。未审计数字表格或执行代码；该问题不建立新的最优性或复现实验结论。

### Q10 — 如何控制每台机器只搜索 N/S 个候选？

- 提问日期：2026-10-10。读者询问 inner parallelization 如何限制机器的搜索范围。
- 来源边界：§2.3 第 7 页规定互不相交子集及搜索任务分配；§3.5 第 14 页采用 N = 2ᵏ、S = 2ˢ。已检查段落没有给出固定前缀的逐门实现；以下是助手用于解释该划分的标准构造，不声称是已核对的作者代码。
- 构造：将完整密钥写成 K = a∥z，每台机器分配一个不同的 s 比特前缀 a，仅对 k − s 比特后缀 z 初始化均匀叠加。每台候选数为 2^(k−s) = N/S；所有前缀一起覆盖整个密钥空间，不需要预先知道秘密密钥前缀。AES 判定仍使用完整密钥 a∥z。
- oracle 相干判定 f(a∥z) 并恢复所需工作空间，只改变候选相位；diffusion 必须在后缀搜索空间内实现，而不是在完整 k 比特密钥空间做标准全局 diffusion。子空间均匀态及扩散：

$$
|u\rangle=\frac{1}{\sqrt{2^{k-s}}}\sum_z|z\rangle,\qquad D_z=2|u\rangle\langle u|-I.
$$

- 每轮在逻辑搜索寄存器上为 I_prefix⊗D_z 接在相位 oracle 后，因此前缀固定、支持集始终留在该机器的子集。只是少做迭代，或只在完整空间的 oracle 中附加前缀判定，都不等同于这种小空间搜索。
- 助手例子：4 比特密钥，4 台机器；分别固定 00、01、10、11 前缀，各自只叠加两个后缀比特，搜索 4 个候选。不是把密码算法的密钥长度变成 2 比特。
- 来源：P03/S02，2023-06-07 修正版，§2.3，第 7 页及 §3.5，第 14 页；子空间初始化及后缀 diffuser 是助手从 Grover 公式作出的实现解释。未检查或执行作者的搜索空间划分代码。

### Q11 — §3.4 的分解不唯一，以及不能稳定获得更稀疏分解，是什么意思？

- 提问日期：2026-10-16。读者询问 “but it is not clear whether sparser decompositions can be consistently obtained with any particular technique” 的含义。
- 回答：这里是同一个可逆二元线性映射矩阵的 PLU 分解；不同消元/主元选择可能给出不同的 P、L、U。更稀疏指 L、U 中需要实现的非对角 1 更少，在作者的直接三角矩阵实现下对应更少 CNOT。分解不唯一不意味着已知一种方法能稳定地产生更稀疏的分解；作者表达的是方法上的未确定性，不是证明这种方法不存在，也不是声称采用的分解最优。他们实际采用 TB97 Algorithm 21.1、SageMath 8.1 的实现。门数减少也不自动保证深度最小。
- 来源：P03/S02，2023-06-07 修正版，§3.4，第 12 页全文及第 13 页 Figure 3 说明；2026-10-16 直接提取本地 PDF 文本检查。非对角 1 与门数的联系为助手对该直接实现的解释；未检查 SageMath 或作者代码，也未验证稀疏分解算法。

### Q12 — §3.5 的 G-cost 和 DW-cost 讲了什么？

- 提问日期：2026-10-16。读者要求解释两种成本模型。
- 回答：G-cost 统计所有并行机器累计执行的门数，对应不向空闲存储收费的被动存储模型；DW-cost 用电路深度乘宽度近似量子比特占用时间，对应每个时间步都需维护/纠错的主动存储模型。作者以最大宽度乘总深度计费，而非逐层活跃宽度求和；可选择只计 T 门或所有门，需保持口径一致。内并行 S 台机器时，每台轮数约为 c_p√(N/S)，总 G-cost 约为 c_p√(NS)G_G，总 DW-cost 约为 c_p√(NS)G_D G_W。固定总深度上限、采用论文的近似与搜索假设时，式 (9)–(10) 分别给出优化单轮 G_D G_G 与 G_D²G_W 的目标，不能仅优化门数或宽度。
- 来源：P03/S02，2023-06-07 修正版，§3.5，第 13–14 页，成本模型定义及式 (5)–(10)；使用 2026-10-16 已提取并检查的本地 PDF 文本。解释不建立未知解数或所有并行策略下的普遍最优性，也不把逻辑电路成本等同于物理硬件报价。

### Q13 — 为什么需要 S 台 inner 并行；相比 outer 并行是否改善成功率和总门成本？

- 提问日期：2026-10-16。读者将并行理解为以宽度换深度的 trade-off，并询问 inner 相对 outer 是否有实际提升。
- 回答：这种 trade-off 理解正确，但论文的 inner 是不相交密钥子空间的多机搜索，不是单次 oracle 内部的电路并行。若单机无法在 MAXDEPTH 内达到目标成功率，多机用于满足深度约束；无该约束时不必为了降低总门数而并行。固定单轮成本下，inner 与 outer 都仅提供 √S 量级的深度加速，没有渐近量级上的差异，也不降低相对于无约束单机的总查询数。但同 S、同 j 下成功率不同：唯一解、均分空间时 inner 为 sin²((2j+1)arcsin√(S/N))，outer 为 1−[1−sin²((2j+1)arcsin(1/√N))]^S。在 j≈(π/4)√(N/S)、大规模近似下，inner 近 1，outer 在大 S 时近 0.915。因此固定高成功率时 inner 可节省常数因子的机器或轮数/门成本。另有条件性优势：分区减小目标所在子集的伪匹配概率，允许减少 oracle 用的明密文对 r，进而可能降低单轮门数/深度；需要额外经典验证，不能视作无条件消除伪匹配。§3.5 的 √S 成本增长默认单轮资源固定，改变 r 后应重新估算。
- 来源：P03/S02，2023-06-07 修正版，§2.2 第 6 页深度限制，§2.3 第 7–8 页两类并行及式 (3)–(4)，§3.5 第 13–14 页。2026-10-16 新检查 §2.2 第 6 页与 §2.3 全文的本地 PDF 提取文本。inner 精确概率式为助手从唯一解 Grover 公式重写；不主张所有轮数下的普遍优势或已复现资源表。

### Q14 — 并行 Grover 结果汇总的通信时间和式 (11) 如何推导？

- 提问日期：2026-10-16。读者询问 “Communication cost to assemble the results in parallel Grover” 段中的公式。
- 回答：二叉树的并发汇总使顺序依赖层数为 O(log S)，不是 S；二维布局中每台机器占地按 G_W 缩放，总占地按 S G_W 缩放，根到叶的 H-tree 路径长度为 O(√(S G_W))。将几何与传播速度换算进 c_S 后，通信时间为 O(log S)+c_S√(S G_W) 个门周期。忽略对数项，搜索深度为 A/√S，其中 A=c_p 2^(k/2)G_D；通信深度为 B√S，其中 B=c_S√G_W。二者相等给出交叉机器数 S*=A/B=2^(k/2)c_pG_D/(c_S√G_W)，共同尺度为 √(AB)=2^(k/4)√(c_pc_SG_D√G_W)，即式 (11)。这是固定单轮电路、二维布局和传播模型下的尺度估算，不是无条件量子搜索下界；严格相加的搜索与末尾通信在该点约为 2√(AB)，论文式 (11) 表示平衡尺度/主导项，而非含全部常数的精确端到端时间。要使通信远小于搜索，应取 S 远小于交叉值，而非只要求不超过。
- 来源：P03/S02，2023-06-07 修正版，§3.5 第 15 页该段及式 (11)、第 16 页接续段，结合第 14 页式 (5)。2026-10-16 新检查第 15–16 页本地 PDF 提取文本。面积到路径长度、A/B 平衡和常数因子核对为助手推导；未核验作者硬件假设或复现数值。

## Selected notes

- [N01 — 振幅放大不等于测量必然成功](notes.md#n01)：2026-10-10，按读者要求用中文保存；包括读者关于测量成功概率的理解、提前测量与重启的区别，以及“满足条件的候选”不一定是原始秘密密钥的限制。
- [N02 — 伪匹配密钥数量与 Grover 旋转角的关系](notes.md#n02)：2026-10-10，按读者要求保存；固定 N 时 M 越大则 θ 和每轮旋转角 2θ 越大，区分找到任一匹配密钥与恢复原始秘密密钥。
- [N03 — PLU 分解不唯一，不等于已知如何稳定得到更稀疏的分解](notes.md#n03)：2026-10-16，按读者要求保存 Q11 的问题与解释，保留直接实现的门数联系及非最优性限制。

<a id="sources"></a>
## Source inventory and inspection coverage

<a id="s01"></a>
### S01 — IACR ePrint primary record and abstract

- Role: target.
- Origin: https://eprint.iacr.org/2019/1146.
- Version: corrected ePrint, 2023-06-07; initial submission 2019-10-03; publication EUROCRYPT 2020. Dates and DOI checked against the primary record.
- Access: remote, checked 2026-09-28. No retained local copy.
- Inspection level: abstract and metadata. Inspected: abstract, correction note, publication metadata, and revision-history summary.
- Supports the contribution summary and version distinction above. Full-text passages have not been newly inspected in this session.

<a id="s02"></a>
### S02 — Corrected ePrint PDF

- Role: target.
- Origin: https://eprint.iacr.org/2019/1146.pdf; downloaded via aPaper on 2026-09-28.
- Version: corrected ePrint, 2023-06-07, identified by the primary record and an exact match to the previously recorded full-text checksum.
- Local copy: [iacr_2019_1146_corrected_2023-06-07.pdf](../../sources/iacr_2019_1146_corrected_2023-06-07.pdf).
- Access: local; PDF signature and file existence verified; 567,820 bytes.
- SHA256: `e1b693ed4e5ec428258fc324f969ca565f7e53f460992fcb68a9f61ca36af4b8`. Compared against all existing shared PDFs; no byte-identical duplicate found.
- Inspection: full_text, selected sections only. On 2026-10-09, inspected §2.1 in full and the opening of §2.2 through the Boolean key-search predicate and spurious-key paragraph, printed/viewer p. 4; formulas visually checked against the rendered PDF page. On 2026-10-10, inspected §2.2's “Depth constraints for cryptanalysis” and “Repeated measurements,” printed/viewer p. 6, including a visual formula check, and the extracted text of §2.2 Remark 2 on p. 7. The intervening spurious-key distribution analysis on p. 5 was not newly audited. Historical selected-section coverage is recorded below. No full-paper proof audit or resource reproduction.
- Additional text inspection on 2026-10-10 for Q09: §2.3, pp. 7–8; §3.5 cost-metric definitions and inner-parallelization derivations, pp. 13–14; §6 opening and §6.1's pair-count discussion/Figure 8 caption, pp. 26–27; §6.2's “Cost estimates under a depth limit,” p. 29; Table 14/15 captions and column descriptions, pp. 33–34. Used existing PDF extraction; numerical table entries and full derivation details were not audited.
- 2026-10-16，Q11：检查 §3.4 全文（第 12 页）与 Figure 3 说明（第 13 页）的本地 PDF 提取文本；未检查所引分解算法或执行实现。
- 2026-10-16，Q12：检查 §3.5 第 13–14 页成本模型定义及式 (5)–(10) 的本地 PDF 提取文本；未执行资源估计或审计后续数值表格。
- 2026-10-16，Q13：检查 §2.2 第 6 页深度限制与 §2.3 第 7–8 页全文，包含式 (3)–(4)；使用本地 PDF 提取文本，未复现攻击或资源表。
- 2026-10-16，Q14：检查 §3.5 第 15 页通信成本段与式 (11)，以及第 16 页接续段的本地 PDF 提取文本；未核验数值或硬件布局。

<a id="s03"></a>
### S03 — Grover STOC 1996 paper (P01/S01)

- Role: prerequisite / notation comparison.
- Origin: [issue attachment](https://github.com/user-attachments/files/32083169/237814.237866.pdf); reuse of [the shared conference PDF](../../sources/grover-stoc-1996.pdf), not a new download or import. Detailed provenance: [P01/S01](../P01/reading.md#s01).
- Version: STOC 1996, pp. 212–219; exact version date unknown. Access: local, verified 2026-10-09.
- SHA256 recorded by P01/S01: `158635c3ebeffc019b4e637f55f991d3f691f5e78614b4e25aeb878246e50e88`.
- Inspection: full_text, selected passages only; §§2–3 and the Hadamard-matrix definition on printed p. 214 / viewer p. 3, visually rechecked 2026-10-09 using the existing page render and PDF extraction.
- Purpose: compare the unique-target predicate, uniform initialization, phase marking, matrix D, and D = F R F with P03 §2.1. Does not transfer P01's wider inspection coverage or establish a complete proof audit.

### Inherited landscape evidence

The existing registry records selected full-text inspection of the introduction, §3.3, §6, and Table 9 in the corrected ePrint, including the omitted diffuser in §6.2 attack costing. That historical coverage is preserved, not treated as new inspection or reader understanding. The earlier inspected copy's checksum matches the now-retained S02 file.

## Artifact inspection

Inherited registry context: [microsoft/grover-blocks at fe65e0b29f6c3c3be02ca839259b91f2e71233bc](https://github.com/microsoft/grover-blocks/tree/fe65e0b29f6c3c3be02ca839259b91f2e71233bc), dated 2023-06-05. Prior inspection covered project metadata only (`aes/cswrapper.csproj` and `INSTALL.md`); no code execution or table reproduction. No artifact inspection was added in this session.
