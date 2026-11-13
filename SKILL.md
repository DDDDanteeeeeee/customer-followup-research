---
name: customer-followup-research
description: 客户跟进研判。给客户或伙伴写跟进邮件前，先自动检测本机可用的数据源（Outlook/Odoo/Obsidian/跟踪表），拉取往来记录，再用公开信息找关联点，最后定一步行动并写邮件。适用于客户久未联系、邮件无回音、老客户重新激活、商机卡住。触发词：跟进研判、客户复联、重新激活、怎么跟进某客户、写跟进邮件、follow-up research。只写邮件格式和语气（不做研判）的任务不适用。
metadata:
  version: "3.0.0"
---

# 客户跟进研判

## 核心思路

先检测本机数据源、查内部、再看外部、最后才写信。

1. **检测环境**：自动扫描本机已运行的服务（Outlook COM、Odoo API、Obsidian、跟踪表文件），报告哪些能连、哪些需要手动提供。
2. **内部先对齐**：用能连的数据源拉取往来时间线，搞清楚上次说到哪、现在是谁在等谁。
3. **外部找关联**：搜对方最近公开做了什么，找出和我们业务的交叉点。
4. **只定一步**：写清楚由谁、在哪天、发给谁、抄送谁，以及发之前先跟内部确认什么。
5. **邮件用来接上联系，不是催单**。

## 执行流程

### 第零步：环境检测

运行检测脚本，报告可用的数据源：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/detect_environment.ps1 -CustomerName "<客户名>"
```

根据检测结果路由数据采集：
- **Outlook available** → 运行 `scripts/read_outlook.ps1 -CustomerName "<客户名>"` 拉取邮件时间线
- **Odoo available** → 运行 `python scripts/read_odoo.py --customer "<客户名>"`（如需凭据，提示用户提供）
- **Obsidian available** → 运行 `scripts/read_files.ps1 -CustomerName "<客户名>"` 搜索相关笔记
- **Tracking files available** → 同上，读取跟踪表
- **连不上的** → 写入"数据缺口"，提示用户手动提供

### 第一步至第五步

按顺序读以下参考文件执行：

1. 读 `references/workflow.md` —— 内部时间线、跟进分型、卡点五查、公开信息、定一步行动。
2. 读 `references/output-template.md` —— 输出结构、邮件写作规则、自查清单、常见错误。
3. 如需要示例，读 `examples/example-alpha-tracking.md`。

## 硬约束

- 邮件里不写价格、折扣、付款条件、交期承诺。
- 不写任何第三方伙伴的数据或名字；不写安全漏洞细节。
- 引用公开新闻必须先打开原文核对。
- 全文控制在 150～200 个英文词。
- 邮件后面附一段"写作说明"。
- 连不上的数据源如实写入"数据缺口"，不编造。
