#!/bin/bash
# 将除 AgentSkillsManager 外的所有 GitHub 仓库设为私有
# 使用: GITHUB_TOKEN=你的PAT ./set-repos-private.sh
#
# Token 权限：经典 Token 勾选 repo；细粒度 Token 需 Administration: Read and write

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

if [ -z "$GITHUB_TOKEN" ]; then
  echo "请设置环境变量 GITHUB_TOKEN（GitHub Personal Access Token）"
  echo "创建: https://github.com/settings/tokens"
  exit 1
fi

exec python3 "$SCRIPT_DIR/set-repos-private.py"
