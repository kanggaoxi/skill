# business-spec-to-golden 评估框架

## 评估理念

**过程规则是手段，产出质量是目的。**

本评估框架聚焦于：agent 是否通过澄清流程，真正理解了用户诉求，并产出了准确的设计文档和正确的 golden 程序。

## 目录结构

```
eval/
├── README.md           # 本文件
├── testcases/          # 测试用例（含预设歧义点）
│   ├── case-01-ambiguous.md    # 多歧义需求，测试歧义识别
│   ├── case-02-multi-system.md # 多子系统需求，测试范围控制
│   └── case-03-simple.md       # 简单需求，含边界歧义
├── validators/         # 确定性验证
│   └── validate.sh     # 验证脚本
├── judges/             # LLM评判
│   └── rubric.md       # 评分标准
└── results/            # 运行结果
    └── [timestamp]/    # 按时间戳存储
```

## 评分维度

### 核心维度（决定是否通过）

| 维度 | 说明 | 权重 |
|------|------|------|
| 歧义识别完整性 | 是否识别出关键歧义 | 关键 |
| 需求理解准确性 | 澄清后是否正确理解意图 | 关键 |
| 设计文档质量 | 9章节完整，决策规则精确 | 关键 |
| Golden正确性 | 测试用例通过率 | 关键 |
| Golden可读性 | 代码易审查程度 | 重要 |

**通过标准**: 核心总分 >= 10/15，且无单项0分

### 过程维度（用于诊断）

| 维度 | 说明 |
|------|------|
| 单问题规则 | 每次只问一个问题 |
| 业务聚焦 | 问业务而非工程 |
| 门控遵守 | 等待用户确认 |

## 修改前后对比评估流程

### 步骤1：基准测试（修改前）

```bash
# 保存当前SKILL.md
cp SKILL.md SKILL.md.backup

# 运行测试用例，记录结果
```

### 步骤2：应用修改

```bash
# 修改SKILL.md
# 应用新的强制约束
```

### 步骤3：对比测试（修改后）

```bash
# 用相同的测试用例运行
# 对比结果
```

### 步骤4：评判

将 session log 和 rubric.md 提交给 LLM 评判，输出格式：

```json
{
  "core_scores": {
    "ambiguity_coverage": {"score": 3, "notes": "识别了8/10个歧义"},
    "understanding_accuracy": {"score": 3, "notes": "完全理解"},
    "design_doc_quality": {"score": 2, "notes": "缺少边界情况示例"},
    "golden_correctness": {"score": 2, "notes": "5/6测试通过"},
    "golden_readability": {"score": 3, "notes": "清晰"}
  },
  "total_core": 13,
  "pass": true
}
```

### 步骤5：对比分析

| 指标 | 修改前 | 修改后 | 变化 |
|------|--------|--------|------|
| 歧义识别 | ? | ? | ? |
| 需求理解 | ? | ? | ? |
| 设计质量 | ? | ? | ? |
| Golden正确性 | ? | ? | ? |

**只有"修改后"在核心维度上优于"修改前"，skill 修改才是有效的。**

## 测试用例说明

| 用例 | 预设歧义数 | 测试重点 |
|------|------------|----------|
| case-01 | 10个 | 歧义识别能力 |
| case-02 | 6个子系统 | 范围控制能力 |
| case-03 | 8个 | 边界情况处理 |

## 快速开始

1. 新开 Claude Code 会话
2. 执行测试用例：
   ```
   Use the business-spec-to-golden skill to process eval/testcases/case-01-ambiguous.md
   ```
3. 完成后保存 session log 到 `eval/results/[timestamp]/`
4. 使用 `rubric.md` 进行评判
5. 记录分数，对比修改前后
