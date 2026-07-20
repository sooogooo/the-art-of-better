# The Art of Better

## 《向上而不自困》

### 积极斯多葛主义心理学重释医美消费与改善型生活消费

一部面向成年消费者的中文电子书：以医疗美容为主要案例，讨论改善欲望、身体意象、比较、面诊、广告、恢复与满意，也把问题延展到职业、关系、金钱与数字生活。

**核心判断**：改善可以是自主行动；把自我价值押给改善结果，则会把行动变成审判。本书提出的“积极斯多葛主义”是作者原创解释框架，不是既有临床学派、诊断工具、心理治疗或医疗建议。

> 我可以追求改善；但我不必把自我价值押在结果上。

## 可直接阅读

| 格式 | 文件 | 说明 |
| --- | --- | --- |
| PDF | [`dist/the-art-of-better.pdf`](dist/the-art-of-better.pdf) | A5 版式，161 页，适合正式阅读与打印。 |
| EPUB | [`dist/the-art-of-better.epub`](dist/the-art-of-better.epub) | 适合电子阅读器。 |
| DOCX | [`dist/the-art-of-better.docx`](dist/the-art-of-better.docx) | 便于编辑与批注。 |
| HTML | [`dist/the-art-of-better.html`](dist/the-art-of-better.html) | 浏览器阅读版。 |

## 书稿与审计

- 正文与附录共 42 个 Markdown 文件，中文字符数 **80,744**。
- 14 项可核查事实主张均有 `F-编号`、来源、限制、日期与正文锚点；14 个引文 ID 均可解析；无缺失锚点、缺失图片或候选性事实主张。
- 20 条参考文献覆盖斯多葛原典与理论、中国医疗美容/广告规范、身体意象、社会比较、共享决策与心理社会结果研究。
- 14 张原创图解与一张原创封面统一采用象牙白、深青蓝、鼠尾草绿和低饱和金色。

事实、推断与价值判断在书中刻意分层：

- **事实**：由 [`research/evidence-ledger.csv`](research/evidence-ledger.csv) 的可追溯来源支撑。
- **推断**：从证据到消费判断的有限解释，保留适用边界。
- **立场**：作者对自主、尊严、风险与改善的价值判断，不伪装为实证结论。

## 构建与复核

```powershell
.\scripts\audit-book.ps1
.\scripts\build.ps1 -Format all
```

构建脚本使用 Pandoc 生成 HTML、EPUB 与 DOCX；仓库已包含经逐页渲染核验的 A5 PDF 发布版。`research/references.json` 为引文数据，`research/evidence-ledger.csv` 为事实台账，`assets/figures/` 为可复核的原创图解源文件。

## 阅读边界

本书不替代医生面诊、知情同意、心理健康评估、诊断、治疗、法律意见或财务建议。任何侵入性或有医疗风险的项目，均应向具有相应资质的医疗机构与专业人员获取个体化信息，并保留充分的考虑时间。

## 版权与素材边界

本仓库由 `sooogooo` 建立。[`research/source-corpus.md`](research/source-corpus.md) 记录主题提炼所参考的既有仓库、具体提交版本与许可证审计。除有明确许可的文件外，书稿不移植上游段落、不把上游自述性数据当作事实证据，也不复制上游图片、图表或第三方素材；`beautifulmind` 因 CC BY-NC-ND 4.0 边界被明确排除在内容、结构与视觉复用之外。
