# Agent 配置路径审计报告

## 当前代码中的 Agent 路径

### 目录扫描型 (Skills 目录)

| Agent | 当前路径 | 状态 | 正确路径 | 说明 |
|-------|---------|------|---------|------|
| Claude Code | `~/.claude/skills/` | ⚠️ 代码中已修正，但用户设置可能不同 | `~/.claude/skills/` | 固定目录，不可修改 |

### MCP 配置型 (JSON 文件)

| Agent | 当前路径 | 状态 | 说明 |
|-------|---------|------|------|
| Cursor | `~/.cursor/mcp.json` | ✅ 正确 | 官方 MCP 配置 |
| VSCode: | `~/.vscode/mcp.json` | ⚠️ 待验证 | 需 MCP 扩展支持 |
| Trae | `~/.Trae/mcp.json` | ⚠️ 待验证 | 字节跳动 IDE |
| Windsurf | `~/.codeium/windsurf/mcp_config.json` | ⚠️ 待验证 | Codeium |
| Antigravity | `~/.antigravity/mcp.json` | ⚠️ 推测 | 小众工具 |
| Qoder | `~/.qoder/mcp.json` | ⚠️ 推测 | 小众工具 |
| CodeBuddy | `~/.codebuddy/mcp.json` | ⚠️ 推测 | 小众工具 |
| Roo Code | `~/.roo/mcp.json` | ⚠️ 推测 | VSCode: 扩展 |
| Cline | `~/.cline/mcp.json` | ⚠️ 推测 | VSCode: 扩展 |
| OpenClaw | `~/.openclaw/openclaw.json` | ⚠️ 待验证 | 小众工具，通过 extraDirs 加载 skills |

### 配置文件型

| Agent | 当前路径 | 状态 | 说明 |
|-------|---------|------|------|
| OpenAI Codex | `~/.codex/agents.json` | ⚠️ 待验证 | 可能不正确 |
| GitHub Copilot CLI | `~/.github/copilot/mcp.json` | ⚠️ 待验证 | 可能不正确 |
| Aider | `~/.aider.conf.yml` | ✅ 正确 | 官方 YAML 配置 |
| Gemini CLI | `~/.gemini/settings.json` | ⚠️ 待验证 | Google 工具 |
| GLM CLI | `~/.glm/config.json` | ⚠️ 待验证 | 智谱 |
| Kimi CLI | `~/.kimi/config.toml` | ⚠️ 待验证 | Moonshot |
| Qwen CLI | `~/.qwen/settings.json` | ⚠️ 待验证 | 阿里 |

## 问题汇总

### 1. 用户设置覆盖问题 ⚠️
- 用户之前修改过 Agent 配置路径
- 这些设置保存在 UserDefaults 中
- 重启应用后会加载用户设置，而不是代码默认值

### 2. 需要确认官方路径的 Agent ⚠️

以下 Agent 的配置路径需要官方文档确认：
- OpenAI Codex
- GitHub Copilot CLI
- Gemini CLI
- GLM CLI
- Kimi CLI
- Qwen CLI
- Roo Code
- Cline
- Trae
- Windsurf
- Antigravity
- Qoder
- CodeBuddy
- OpenClaw

## 建议

1. 添加"重置为默认"功能
2. 对于固定路径的 Agent（如 Claude Code），不允许用户修改路径
3. 在 UI 中显示哪些是官方确认的路径，哪些是推测的
