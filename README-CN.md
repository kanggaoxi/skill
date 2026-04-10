# business-spec-to-golden

一个 Claude Code Skill，用于将需求文档转换为经过评审的交付规格和测试验证过的黄金参考程序。

## 概述

本 Skill 将模糊需求转换为：

1. **工作模型理解文档** - 便于纠偏的理解基线，区分源事实与 agent 的解释
2. **分阶段问题清单** - 分开的 P0、P1、P2 ledger，并带问题收敛机制
3. **分层基线产物** - 结构、模块、边界三个阶段产物
4. **经过评审的交付规格** - 可独立交付的 spec 先经隔离 review，再进入用户确认
5. **已确认的测试计划与可执行测试** - 基于用户样例锚点扩展测试，再生成测试代码
6. **黄金参考程序** - 通过测试与覆盖率门槛的参考实现

## 核心特性

- **工作模型理解** - 先暴露 scope、结构和歧义点，再深入提问
- **按阶段生成问题** - 不再一开始生成完整大问题表
- **问题收敛机制** - 新答案可以覆盖、作废或替代后续问题
- **基线产物** - 每个阶段都沉淀为后续阶段的压缩输入
- **隔离式 Spec Review** - 交付规格先由独立子代理审查，再交给用户确认
- **用户锚点驱动的测试设计** - 正式 test plan 先基于用户样例，再由 agent 扩展覆盖
- **设计冻结与测试冻结** - 代码生成前必须先确认 spec 和 test plan
- **覆盖率门槛** - 黄金程序不仅要跑通测试，还要满足覆盖率要求

## 单一 Skill

这个仓库只维护一个 `SKILL.md`，详细格式规范下沉到 `references/`。

## 工作流

```
1. 工作模型理解 → *-understanding.md
2. P0 澄清 → *-p0-questions.md → *-global-flow.md
3. P1 澄清 → *-p1-questions.md → *-submodule-design.md
4. P2 澄清 → *-p2-questions.md → *-boundary-rules.md
5. 规格文档 → *-spec.md
6. 隔离规格评审 → *-spec-review.md
7. 用户确认与设计冻结
8. 收集用户样例 → 测试计划 → *-test-plan.md
9. 可执行测试 → *-test.js / *-test.py
10. 黄金程序 → 测试与覆盖率门槛
```

## P0/P1/P2 分层定义

| 层级 | 范围 | 问题类型 |
|------|------|----------|
| **P0** | 结构级 | scope、模块边界、系统级 I/O、主流程、结构性交接 |
| **P1** | 正常路径模块行为 | 模块职责、业务输入/输出、转换逻辑、规则优先级 |
| **P2** | 边界与失败行为 | 缺失输入、无效值、重复/冲突、拒绝与报错行为 |

## 输出文件

所有文件保存在 `docs/business-specs/YYYY-MM-DD-<topic>-*`：

| 文件 | 内容 |
|------|------|
| `*-understanding.md` | 工作模型理解与歧义列表 |
| `*-p0-questions.md` | 结构级问题清单 |
| `*-p1-questions.md` | 正常路径问题清单 |
| `*-p2-questions.md` | 边界/失败问题清单 |
| `*-global-flow.md` | 结构基线 |
| `*-submodule-design.md` | 正常路径模块基线 |
| `*-boundary-rules.md` | 边界决策矩阵 |
| `*-spec.md` | 完整交付规格，也是下游唯一业务真源 |
| `*-spec-review.md` | 交付规格的隔离审查结果 |
| `*-test-plan.md` | 人类可读的测试计划与映射 |
| `*-test.js` / `*-test.py` | 带 CLI 与 coverage 命令的可执行测试 |

## 使用方法

```
/business-spec-to-golden
```

或直接提供需求文档：

```
这是我的产品需求文档 [附上文档]。
请帮我生成交付规格和参考实现。
```

## 测试驱动的黄金程序

黄金程序必须在 spec 完成隔离 review、且 test plan 建立在用户样例之上后，才进入实现阶段：

1. 通过隔离子代理审查 `*-spec.md` 并记录结果
2. 收集用户提供的 canonical examples 与 must-not-break behaviors
3. 先按测试类别收敛，再生成 `*-test-plan.md`
4. 再生成带 CLI 与 coverage 命令的可执行测试
5. 实现黄金程序
6. 迭代直到所有测试通过
7. 满足覆盖率门槛（默认 `>= 80%`，纯业务逻辑优先 `>= 90%`）

## 独立交付规则

`*-spec.md` 必须是可单独交付的文档。新开一个会话，只给这个文件，也应当能够继续设计测试并生成 golden。`*-understanding.md`、`*-global-flow.md`、`*-submodule-design.md`、`*-boundary-rules.md` 只负责澄清与追溯，不允许独占任何影响测试或可见行为的业务规则。

## 文件结构

```
business-spec-to-golden/
├── SKILL.md
├── README.md
├── README-CN.md
└── references/
    ├── artifact-header-template.md
    ├── spec-template.md
    ├── spec-document-reviewer-prompt.md
    ├── spec-review-template.md
    └── test-plan-template.md
```

## 许可证

MIT
