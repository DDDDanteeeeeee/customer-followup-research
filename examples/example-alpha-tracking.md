# 示例：Alpha Tracking Co. 跟进研判（虚构）

> 本示例全部人名、公司名、数据和链接均为虚构，用于培训。实际使用时替换为真实客户信息并标注保密等级。

文件头：保密 · 内部训练用 · 起草人 Codex · 2026-11-13

## 一句话结论

Alpha Tracking 我方 10-14 发信后对方未回复，且我方答应的固件升级包至今未交付。属于类型 ① 加 ③。本周应先向对方坦承固件进度，再问规划是否改变；本周五（11-15）由 Alice 发出，抄送 Bob。

## 1. 上次接触（时间线表）

| 日期 | 事件 | 来源 |
| --- | --- | --- |
| 2025-08-20 | Alpha 下单 500 台 AT-200 跟踪器 | CRM 订单 #4102 |
| 2025-09-15 | 发货完成 | 物流跟踪 |
| 2025-10-14 | Alice 发邮件约视频会议 | Sent Messages 主题 "AT-200 deployment review" |
| 2025-10-20 | Alpha 采购经理 Jane 回复 "we are evaluating alternatives" | Inbox 原文 |
| 2025-11-09 | 我方承诺的固件 v2.1 尚未交付 | 技术周报 |

**最后一行**：10-14 我方发信，Jane 10-20 回复后我方未再跟进，现在是我方在等我方自己定下一步；等了 24 天。固件承诺距上次提及已 26 天。

## 2. 卡点

| 编号 | 卡点 | 性质 | 依据 |
| --- | --- | --- | --- |
| 1 | 需求信号弱：跟踪表显示"预计 Q4 追加 200 台"但无新询价 | 事实 | CRM 无新商机 |
| 2 | 联系人可能变更：Jane 在 10-20 提到"team is being restructured" | 事实 | 邮件原文 |
| 3 | 我方欠账：固件 v2.1 承诺 10-09 至今未交付 | 事实 | 技术周报 |
| 4 | 商务风险：Jane 用词 "evaluating alternatives" 暗示考虑竞品 | Agent 判断 | 原话引用 |
| 5 | 时间：Q4 目标期 12-31，如果 11 月底前不能确认意向，赶不上目标期 | 事实 | 交期倒推 |

## 3. 他们的近况（公开信息表，加关联点）

| 日期 | 来源 | 核对状态 | 信息 | 与我们的关联 |
| --- | --- | --- | --- | --- |
| 2025-11-05 | example.com/news/alpha-expands | 已打开原文 | Alpha 扩建了仓库，部署 IoT 仓库系统 | 我们的 AT-200 可与其新系统对接 |
| 2025-11-08 | example.com/blog/alpha-cto | 已打开原文 | CTO 发文谈 IoT 追踪的未来 | 与 AT-200 v2.1 定位匹配 |
| 未找到 | — | — | Alpha 与竞品签约的公开信息 | 无 |

## 4. 建议的一步

| 要素 | 内容 |
| --- | --- |
| 谁 | Alice Chen（销售经理） |
| 哪天 | 2025-11-15（本周五） |
| 发给谁 | 方案 A：Jane（前采购经理）→ 风险：可能已换岗<br>方案 B：CTO（公开博客署名）→ 风险：级别太高，日常事务不合适 |
| 抄送谁 | Bob（技术支持），因为固件进度需要技术口径 |
| 发之前确认 | 与工程团队确认固件 v2.1 当前 ETA，避免邮件里再次空口承诺 |
| 没回音的后手 | 5 个工作日后（11-22）电话跟进 |
| 止损点 | 如果 11-30 前仍无意向，转入 2026 Q1 跟踪，不再占用本周产出资源 |

## 5. 英文邮件草稿（含中文对照和写作说明）

**Subject**: AT-200 at your new warehouse — quick update and a few questions

Hi Jane,

I saw that Alpha recently expanded its warehouse and is rolling out a new IoT tracking system — great timing. I also wanted to share that our firmware v2.1, which adds the integration APIs we discussed, is now in internal testing.

A few quick questions:

1. How has the AT-200 been performing in your current deployment?
2. Has the team restructuring changed who manages procurement or the IoT project?
3. Are there features in the new system that our firmware should support?

If it would help, I'm happy to set up a 20-minute call in the next two weeks.

Best,
Alice

**中文对照**：

Jane 你好，

看到 Alpha 最近扩建了仓库并上线新的 IoT 追踪系统——时机很好。同时想跟你同步：我们之前讨论的固件 v2.1（增加了集成 API）已进入内部测试。

几个快速问题：

1. 目前 AT-200 在你们那边的部署运行得怎么样？
2. 团队调整后，采购和 IoT 项目现在由谁负责？
3. 新系统有什么功能是我们固件应该支持的？

如果方便，我很乐意在接下来两周内约一次 20 分钟的电话。

Alice

**写作说明**：
- 开头用对方的公开进展（仓库扩建 + IoT 系统），不用 "just following up"。
- 第 2 段先主动交代固件进展，回应类型 ③ 欠账。
- 问题 1 确认现状（类型 ②），问题 2 确认联系人变更（类型 ①），问题 3 排除方案变更风险。
- 请求很小：20 分钟电话。

## 6. 需要决策人决定的事

1. 固件 v2.1 的实际 ETA，确认后才能发邮件（否则不要写进邮件）。
2. 是否接受"如果 11-30 前仍无意向就转入明年跟踪"的止损点。

## 7. 数据缺口

- Alpha 当前 IoT 项目负责人姓名（公开信息未找到，需通过 Jane 或 CTO 确认）。
- 固件 v2.1 的具体 ETA（需要工程团队提供）。
- 跟踪表中 "Q4 追加 200 台" 的来源和依据（未核对）。
