# Agent 配置路径变更报告

## 变更日期
2026-03-10

## 主要变更

### 1. Cursor ✅ 已修正
| 项目 | 旧配置 | 新配置 |
|-----|-------|-------|
| ID | `cursor` + `cursor-editor` (重复) | `cursor` (统一) |
| 路径 | `~/.cursor/skills-cursor/` (不正确) | `~/.cursor/mcp.json` (官方MCP) |
| 方式 | 目录扫描 | MCP JSON 配置 |

**说明**: Cursor 官方使用 MCP (Model Context Protocol) 配置，而非 skills 目录。

### 2. OpenAI Codex ⚠️ 待验证修改
| 项目 | 旧配置 | 新配置 |
|-----|-------|-------|
| 路径 | `~/.codex/skills/` (可能不正确) | `~/.codex/agents.json` (待验证) |
| 格式 | TOML | JSON |

**说明**: Codex 使用 "agents" 概念而非 "skills"，配置方式待官方文档确认。

### 3. GitHub Copilot CLI ⚠️ 待验证修改
| 项目 | 旧配置 | 新配置 |
|-----|-------|-------|
| 路径 | `~/.copilot/mcp-config.json` | `~/.github/copilot/mcp.json` (待验证) |

### 4. 小众工具统一改为 MCP 配置
以下工具的配置从自定义格式改为标准 MCP 配置（待验证）：

| Agent | 旧配置 | 新配置 |
|-------|-------|-------|
| Antigravity | `~/.agent/skills/config.json` | `~/.antigravity/mcp.json` |
| Qoder | `~/.qoder/skills/config.json` | `~/.qoder/mcp.json` |
| CodeBuddy | `~/.codebuddy/skills/config.json` | `~/.codebuddy/mcp.json` |
| Roo Code | `~/.roo/rules` (目录) | `~/.roo/mcp.json` |
| Cline | `~/.cline/rules` (目录) | `~/.cline/mcp.json` |
| OpenClaw | `~/.openclaw/openclaw.json` | `~/.openclaw/openclaw.json` | 通过 extraDirs 加载 skills 目录 |

**说明**: MCP (Model Context Protocol) 是行业标准协议，越来越多工具采用此标准。

---

## 配置验证状态

### ✅ 已验证 (官方文档/实测确认)
1. **Claude Code**: `~/.claude/skills/` - 官方文档确认
2. **Aider**: `~/.aider.conf.yml` - 官方文档确认
3. **Cursor**: `~/.cursor/mcp.json` - 官方文档确认

### ⚠️ 推测配置 (需要用户验证)
4. **OpenAI Codex**: `~/.codex/agents.json`
5. **GitHub Copilot CLI**: `~/.github/copilot/mcp.json`
6. **VSCode:**: `~/.vscode/mcp.json`
7. **Trae**: `~/.Trae/mcp.json`
8. **Windsurf**: `~/.codeium/windsurf/mcp_config.json`
9. **Gemini CLI**: `~/.gemini/settings.json`
10. **GLM CLI**: `~/.glm/config.json`
11. **Kimi CLI**: `~/.kimi/config.toml`
12. **Qwen CLI**: `~/.qwen/settings.json`
13. **Roo Code**: `~/.roo/mcp.json`
14. **Cline**: `~/.cline/mcp.json`
15. **Antigravity**: `~/.antigravity/mcp.json`
16. **Qoder**: `~/.qoder/mcp.json`
17. **CodeBuddy**: `~/.codebuddy/mcp.json`
18. **OpenClaw**: `~/.openclaw/mcp.json`

---

## 技术实现更新

### 修复硬编码路径问题
三个目录扫描型 Agent 现在正确使用 `agent.configPath`：

```swift
// 修复前
let skillsDir = "\(homeDir)/.claude/skills"  // 硬编码

// 修复后
let skillsDir = getAgentConfigPath(agent)     // 使用配置路径
```

涉及函数：
- `applySkillsToClaudeDirectory`
- `applySkillsToCursorDirectory`
- `applySkillsToCodexDirectory`

---

## 用户使用建议

### 如果某个 Agent 检测不到 Skills...
1. 检查 Agent 的配置路径是否正确
2. 参考官方文档确认配置位置
3. 在应用中手动修改配置路径
4. 重新应用配置

### 建议验证的配置
以下 Agent 建议用户帮助验证实际配置路径：
- OpenAI Codex
- GitHub Copilot CLI
- 国内 CLI 工具 (Gemini/GLM/Kimi/Qwen)
- VSCode: MCP 扩展
- Roo Code / Cline

如有确认的配置，请提交 Issue 更新。

---

## 参考文档

- Claude Code Skills: https://docs.anthropic.com/en/docs/agents-and-tools/claude-code
- Aider Config: https://aider.chat/docs/config.html
- Cursor MCP: https://docs.cursor.com/mcp
- MCP Protocol: https://modelcontextprotocol.io
