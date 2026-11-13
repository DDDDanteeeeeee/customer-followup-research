# customer-followup-research

客户跟进研判技能。给客户或伙伴写跟进邮件之前，先把我方和对方的往来理清楚，再用公开信息找到跟我们过往业务的关联点，最后定下一步行动并写邮件。

## 安装

把 `customer-followup-research/` 文件夹复制到你的 Codex skills 目录：

```bash
# Windows
xcopy /E /I customer-followup-research "%CODEX_HOME%\skills\customer-followup-research"

# macOS / Linux
cp -r customer-followup-research "${CODEX_HOME:-$HOME/.codex}/skills/customer-followup-research"
```

安装后重启 Codex 即可。

## 使用

对 Codex 说：

> 帮我做一下 XX 客户的跟进研判
> /customer-followup-research XX 客户

或使用触发词：跟进研判、客户复联、重新激活、怎么跟进某客户、写跟进邮件、follow-up research。

## 结构

```
customer-followup-research/
├── SKILL.md                        # 入口：核心思路、执行流程、硬约束
├── references/
│   ├── workflow.md                 # 五步流程：时间线→分型→卡点→公开信息→定一步
│   └── output-template.md          # 输出模板、邮件规则、自查清单、常见错误
├── examples/
│   └── example-alpha-tracking.md   # 虚构完整示例（类型①+③）
├── agents/
│   └── openai.yaml                 # UI 元数据
├── LICENSE
└── README.md
```

## 来源

基于《客户跟进研判》第 2 版（2026-11-13）提炼。
