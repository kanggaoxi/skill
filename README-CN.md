# business-spec-to-golden

一个 Codex Skill，用于把不可靠的原始设计文档和少量测试用例，转成澄清后的 spec、可执行测试和 golden 程序。

## 定位

这个 Skill 不绑定某一个狭窄业务场景。它解决的是这类问题：

- 原始设计文档可能不完整、有误、含大量领域术语，或者前后矛盾
- 用户手里只有少量测试用例
- agent 需要帮用户澄清实现目标，但不能用大量细碎问题打扰开发
- 最终要产出经过测试验证的 golden 标准实现

默认实现 profile 是 Python、`pytest` 和 `golden.py`。只有用户明确要求或仓库环境强约束时，才切换到其他语言。

## 核心特性

- **证据分层**：区分原始文档事实、用户测试事实、用户确认、agent 推断和显式假设
- **P0/P1/P2 分层收敛**：保留分层澄清思想，但按层生成问题，不一次性展开
- **问题预算**：每层只问最小一批高影响问题
- **P2 可选**：边界/冲突细节由开发决定是否投入时间继续澄清
- **低质量文档防误导**：记录文档和测试用例冲突，不把看似正式的原文直接当真理
- **独立 spec**：所有影响 golden 的规则都折入 `*-spec.md`
- **spec review gate**：spec 先评审，再让用户确认和进入测试
- **测试先行**：先写可执行测试，再写 `golden.py`
- **可选测试 harness**：只有测试加载或 expected-output 比较变复杂时才生成

## 工作流

```
1. 理解阶段 → *-understanding.md
2. P0 系统契约 → *-p0-questions.md → *-global-flow.md
3. P1 核心行为 → *-p1-questions.md → *-submodule-design.md
4. 可选 P2 边界/冲突/默认行为 → *-p2-questions.md → 可选 *-boundary-rules.md
5. Spec → *-spec.md
6. Spec review → *-spec-review.md
7. 用户确认
8. Test plan → *-test-plan.md
9. 可执行测试 → *-test.py
10. Golden 程序 → golden.py
```

## P0/P1/P2 语义

| 层级 | 目的 | 典型问题 |
|------|------|----------|
| P0 | Golden 范围和系统契约 | 输入、输出、处理范围、外部契约、权威测试用例 |
| P1 | 正常路径核心行为 | 提取、映射、计算、转换、过滤、聚合、排序、优先级 |
| P2 | 可选的边界和冲突行为 | 缺失输入、非法值、重复、冲突、默认值、错误/拒绝行为 |

agent 不应该一次性抛出所有问题。每层都有候选池、排序后的问题预算和基线摘要。P2 只有在开发选择 full 或 critical-only 边界澄清时才进入；否则把跳过的 P2 风险记录进 spec。

## 输出文件

默认保存在 `docs/business-specs/YYYY-MM-DD-<topic>-*`：

| 文件 | 内容 |
|------|------|
| `*-understanding.md` | 工作理解、证据分层、信任和冲突记录 |
| `*-p0-questions.md` | P0 候选问题和决策 |
| `*-global-flow.md` | 已确认的系统契约基线 |
| `*-p1-questions.md` | P1 候选问题和决策 |
| `*-submodule-design.md` | 已确认的核心行为基线 |
| `*-p2-questions.md` | P2 候选问题和决策 |
| `*-boundary-rules.md` | P2 执行时的边界/冲突/默认行为基线 |
| `*-spec.md` | 可独立指导 golden 生成的 spec |
| `*-spec-review.md` | 阻塞式 spec 评审结果 |
| `*-test-plan.md` | 简洁测试计划和可执行映射 |
| `*-test.py` | pytest 测试 |
| `*-cases.json` | 可选测试用例数据 |
| `golden_test_harness.py` | 可选的用例加载和 expected-output 比较辅助 |
| `golden.py` | golden 标准实现 |

## Profiles

主流程是通用的。当前内置了这些默认指导：

- Python golden 生成
- 模型推理前的 CPU 前处理
- 通信或其他领域术语密集的原始文档

只有任务匹配时才应用 profile-specific 检查。

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
