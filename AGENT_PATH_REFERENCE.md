# Agent 配置路径对照表

## 目录扫描型 Agent (固定路径)

| Agent | Skills 目录 | 说明 |
|-------|------------|------|
| **Claude Code** | `~/.claude/skills/` | 官方固定路径，不可修改 |
| **Cursor** | `~/.cursor/skills/` | 传统方式，现在主要用 MCP |
| **Codex** | `~/.codex/agents/` | Codex 使用 agents 而非 skills |
| **Roo Code** | `~/.roo/rules/` | VSCode: 扩展 |
| **Cline** | `~/.cline/rules/` | VSCode: 扩展 |

## MCP 配置型 Agent (JSON 文件)

| Agent | 配置文件 | 说明 |
|-------|---------|------|
| **Cursor** | `~/.cursor/mcp.json` | 推荐方式 |
| **VSCode:** | `~/.vscode/mcp.json` | 需安装 MCP 扩展 |
| **Trae** | `~/.Trae/mcp.json` | 字节跳动 IDE |
| **Windsurf** | `~/.codeium/windsurf/mcp_config.json` | Codeium IDE |
| **GitHub Copilot** | `~/.github/copilot/mcp.json` | 待验证 |

## 配置文件型 Agent

| Agent | 配置文件 | 格式 |
|-------|---------|------|
| **Aider** | `~/.aider.conf.yml` | YAML |
| **Gemini CLI** | `~/.gemini/settings.json` | JSON |
| **GLM CLI** | `~/.glm/config.json` | JSON |
| **Kimi CLI** | `~/.kimi/config.toml` | TOML |
| **Qwen CLI** | `~/.qwen/settings.json` | JSON |

## 代码修正说明

### 问题根源
- 之前的代码使用 `getAgentConfigPath(agent)` 读取用户设置的 `configPath`
- 但用户可能误修改了路径（如把 `~/.claude/skills/` 改成了 `~/.claude.json`）
- 导致 Skills 被创建到了错误的位置

### 修正方案
- 对于使用**固定目录**的 Agent（Claude Code, Codex 等），代码中硬编码正确的路径
- 对于使用**配置文件**的 Agent，使用 `getAgentConfigPath(agent)` 读取用户设置的路径
- 在 UI 中区分"Skills 目录"和"配置文件"两种类型

### 修正后的代码示例

```swift
// Claude Code - 使用固定目录
private func applySkillsToClaudeDirectory(agent: Agent, skills: [InstalledSkill]) {
    let homeDir = NSHomeDirectory()
    let skillsDir = "\(homeDir)/.claude/skills"  // 硬编码固定路径
    // ...
}

// Cursor MCP - 使用配置文件路径
private func applySkillsToMCPConfig(agent: Agent, skills: [InstalledSkill], configPath: String) {
    let configFile = getAgentConfigPath(agent)  // 读取用户设置
    // ...
}
```
