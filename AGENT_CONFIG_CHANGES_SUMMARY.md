# Agent 配置更新摘要

> 更新日期: 2026-03-11

## 修改汇总

### 已修正的 Agent

| Agent | 修改项 | 旧配置 | 新配置 |
|-------|-------|--------|--------|
| **OpenAI Codex** | 配置文件路径 | `~/.codex/agents.json` | `~/.codex/config.json` |
| **Roo Code** | 配置类型+路径 | `~/.roo/mcp.json` (file) | `~/.roo/rules/` (directory) |
| **Cline** | 配置类型+路径 | `~/.cline/mcp.json` (file) | `~/.cline/rules/` (directory) |
| **OpenClaw** | 配置文件路径 | `~/.openclaw/mcp.json` | `~/.openclaw/openclaw.json` |

---

## 详细说明

### 1. OpenAI Codex
```swift
// 修改前
configPath: "~/.codex/agents.json"

// 修改后
configPath: "~/.codex/config.json"
```
**原因**: `agents.json` 不太可能是标准路径，`config.json` 更符合惯例。

---

### 2. Roo Code
```swift
// 修改前
configPath: "~/.roo/mcp.json"
configType: .file

// 修改后
configPath: "~/.roo/rules/"
configType: .directory
```
**原因**:
- Roo Code 是 VSCode: 扩展，不是独立 MCP 服务
- 根据之前的参考文档，Roo Code 使用 `~/.roo/rules/` 目录

---

### 3. Cline
```swift
// 修改前
configPath: "~/.cline/mcp.json"
configType: .file

// 修改后
configPath: "~/.cline/rules/"
configType: .directory
```
**原因**:
- Cline 是 VSCode: 扩展，不是独立 MCP 服务
- 根据之前的参考文档，Cline 使用 `~/.cline/rules/` 目录

---

### 4. OpenClaw
```swift
// 修改前
configPath: "~/.openclaw/mcp.json"

// 修改后
configPath: "~/.openclaw/openclaw.json"
```
**原因**: 代码中实际使用的是 `openclaw.json`，preset 中配置错误。

---

## 当前所有 Agent 配置一览

| # | Agent | 类型 | 配置路径 | 格式 | 状态 |
|---|-------|------|---------|------|------|
| 1 | Claude Code | directory | `~/.claude/skills/` | JSON | ✅ 已验证 |
| 2 | OpenAI Codex | file | `~/.codex/config.json` | JSON | ⚠️ 待验证 |
| 3 | GitHub Copilot CLI | file | `~/.github/copilot/mcp.json` | JSON | ⚠️ 待验证 |
| 4 | Aider | file | `~/.aider.conf.yml` | YAML | ✅ 已验证 |
| 5 | Cursor | file | `~/.cursor/mcp.json` | JSON | ✅ 已验证 |
| 6 | Gemini CLI | file | `~/.gemini/settings.json` | JSON | ⚠️ 推测 |
| 7 | GLM CLI | file | `~/.glm/config.json` | JSON | ⚠️ 推测 |
| 8 | Kimi CLI | file | `~/.kimi/config.toml` | TOML | ⚠️ 推测 |
| 9 | Qwen CLI | file | `~/.qwen/settings.json` | JSON | ⚠️ 推测 |
| 10 | VSCode: | file | `~/.vscode/mcp.json` | JSON | ⚠️ 待验证 |
| 11 | Trae | file | `~/.Trae/mcp.json` | JSON | ⚠️ 推测 |
| 12 | Antigravity | file | `~/.antigravity/mcp.json` | JSON | ⚠️ 推测 |
| 13 | Qoder | file | `~/.qoder/mcp.json` | JSON | ⚠️ 推测 |
| 14 | Windsurf | file | `~/.codeium/windsurf/mcp_config.json` | JSON | ⚠️ 推测 |
| 15 | CodeBuddy | file | `~/.codebuddy/mcp.json` | JSON | ⚠️ 推测 |
| 16 | Roo Code | **directory** | **`~/.roo/rules/`** | JSON | ⚠️ 待验证 |
| 17 | Cline | **directory** | **`~/.cline/rules/`** | JSON | ⚠️ 待验证 |
| 18 | OpenClaw | file | `~/.openclaw/openclaw.json` | JSON | ⚠️ 已修正 |

---

## 仍需验证的 Agent

### 高优先级
1. **OpenAI Codex** - 确认 `~/.codex/config.json` 是否正确
2. **Roo Code** - 确认是否为 `~/.roo/rules/` 目录
3. **Cline** - 确认是否为 `~/.cline/rules/` 目录

### 中优先级
4. VSCode: MCP 配置路径
5. Trae MCP 配置路径
6. Windsurf 配置路径

### 低优先级
7. 国内 CLI (Gemini/GLM/Kimi/Qwen)
8. 小众工具 (Antigravity/Qoder/CodeBuddy)
9. GitHub Copilot CLI 是否支持自定义 skills

---

## 如何测试验证

1. 安装对应的 Agent 工具
2. 检查实际创建的配置文件/目录位置
3. 尝试添加 skill，查看是否生效
4. 向官方文档或社区确认配置方式

如有验证结果，请更新 `AGENT_CONFIG_VERIFICATION.md` 文件。
