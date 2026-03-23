#!/bin/bash
# 确定性验证脚本
# 检查输出是否符合基本结构要求

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EVAL_DIR="$(dirname "$SCRIPT_DIR")"
RESULTS_DIR="${EVAL_DIR}/results"

echo "=== business-spec-to-golden 确定性验证 ==="
echo ""

# 检查是否有运行结果
if [ ! -d "$RESULTS_DIR" ]; then
    echo "FAIL  没有找到结果目录: $RESULTS_DIR"
    exit 1
fi

# 找到最新的运行结果
LATEST_RUN=$(ls -t "$RESULTS_DIR" 2>/dev/null | head -1)
if [ -z "$LATEST_RUN" ]; then
    echo "FAIL  没有找到运行结果"
    exit 1
fi

RUN_DIR="$RESULTS_DIR/$LATEST_RUN"
echo "INFO  检查运行: $LATEST_RUN"
echo ""

# 检查session log是否存在
PASS_COUNT=0
FAIL_COUNT=0

check_file() {
    local file_pattern="$1"
    local description="$2"

    if ls "$RUN_DIR"/$file_pattern 1>/dev/null 2>&1; then
        echo "PASS  $description"
        ((PASS_COUNT++))
    else
        echo "FAIL  $description"
        ((FAIL_COUNT++))
    fi
}

check_content() {
    local file="$1"
    local pattern="$2"
    local description="$3"

    if [ -f "$file" ] && grep -q "$pattern" "$file" 2>/dev/null; then
        echo "PASS  $description"
        ((PASS_COUNT++))
    else
        echo "FAIL  $description"
        ((FAIL_COUNT++))
    fi
}

# 基本文件检查
check_file "*.jsonl" "Session log 存在"

# 设计文档检查（如果已生成）
DESIGN_DOC=$(find "$RUN_DIR" -name "*.md" -type f 2>/dev/null | head -1)
if [ -n "$DESIGN_DOC" ]; then
    echo ""
    echo "--- 设计文档检查 ---"

    check_content "$DESIGN_DOC" "Objective\|目标" "设计文档: 包含Objective章节"
    check_content "$DESIGN_DOC" "Domain Model\|领域模型" "设计文档: 包含Domain Model章节"
    check_content "$DESIGN_DOC" "Input Contract\|输入" "设计文档: 包含Input Contract章节"
    check_content "$DESIGN_DOC" "Output Contract\|输出" "设计文档: 包含Output Contract章节"
    check_content "$DESIGN_DOC" "Decision Rules\|决策规则" "设计文档: 包含Decision Rules章节"
fi

# 黄金程序检查（如果已生成）
CODE_FILE=$(find "$RUN_DIR" -name "*.py" -o -name "*.ts" -o -name "*.js" 2>/dev/null | head -1)
if [ -n "$CODE_FILE" ]; then
    echo ""
    echo "--- 黄金程序检查 ---"

    echo "PASS  黄金程序文件存在: $(basename $CODE_FILE)"
    ((PASS_COUNT++))
fi

# 总结
echo ""
echo "=== 验证总结 ==="
echo "PASS: $PASS_COUNT"
echo "FAIL: $FAIL_COUNT"

if [ $FAIL_COUNT -eq 0 ]; then
    echo ""
    echo "所有确定性检查通过"
    exit 0
else
    echo ""
    echo "存在失败的检查项"
    exit 1
fi
