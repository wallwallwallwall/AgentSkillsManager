# Agent 官方配置路径整理

## 已验证的 Agent 配置路径

### 1. Claude Code ✅
- **官方文档**: https://docs.anthropic.com/en/docs/agents-and-tools/claude-code
- **Skills 目录**: `~/.claude/skills/`
- **配置方式**: 目录扫描，每个 skill 是一个包含 SKILL.md 的文件夹
- **状态**: ✅ 已验证正确

### 2. OpenAI Codex ⚠️
- **官方仓库**: https://github.com/openai/codex
- **配置路径**: Codex 使用 `~/.codex/` 目录，但主要是存储配置和缓存
- **Skills/Agents 配置**: Codex 使用 `agents.json` 或类似的 agent 配置文件
- **注意**: Codex 的 "skills" 概念与 Claude Code 不同，可能不支持目录扫描方式
- **建议**: 需要进一步验证，暂时保留但可能不适用

### 3. Cursor ✅
- **官方文档**: https://docs.cursor.com/mcp
- **MCP 配置**:
  - macOS: `~/Library/Application Support/Cursor/User/globalStorage/mcp.json`
  - 或: `~/.cursor/mcp.json`
- **说明**: Cursor 通过 MCP (Model Context Protocol) 配置，使用 JSON 文件
- **当前代码问题**:
  - `cursor`: `~/.cursor/skills-cursor/` ❌ 不正确
  - `cursor-editor`: `~/.cursor/mcp.json` ⚠️ 部分正确
- **修正建议**:
  - 统一使用 MCP 配置方式
  - 路径应为 `~/.cursor/mcp.json` 或 `~/.config/Cursor/mcp.json`

### 4. Aider ✅
- **官方文档**: https://aider.chat/docs/config.html
- **配置文件**: `~/.aider.conf.yml`
- **说明**: YAML 格式的配置文件
- **状态**: ✅ 已验证正确

### 5. VSCode: (MCP 扩展) ✅
- **MCP 配置**: `~/.vscode/mcp.json` 或工作区 `.vscode/mcp.json`
- **说明**: 通过 MCP 扩展配置
- **状态**: ⚠️ 路径可能正确，但需要确认 VSCode: MCP 扩展的具体配置方式

### 6. Trae
- **MCP 配置**: `~/.Trae/mcp.json`
- **说明**: 字节跳动的 IDE，类似 Cursor 支持 MCP
- **状态**: ⚠️ 需要验证

### 7. Windsurf
- **MCP 配置**: `~/.codeium/windsurf/mcp_config.json`
- **说明**: Codeium 的 IDE，支持 MCP
- **状态**: ⚠️ 需要验证

### 8. Roo Code (VSCode: 扩展)
- **配置目录**: `~/.roo/rules/`
- **说明**: VSCode: 扩展，使用目录方式
- **状态**: ⚠️ 需要验证

### 9. Cline (VSCode: 扩展)
- **配置目录**: `~/.cline/rules/`
- **说明**: VSCode: 扩展，使用目录方式
- **状态**: ⚠️ 需要验证

### 10. GitHub Copilot CLI
- **MCP 配置**: `~/.copilot/mcp-config.json`
- **说明**: 使用 MCP 配置
- **状态**: ⚠️ 需要验证

### 11. Gemini CLI
- **配置**: `~/.gemini/settings.json`
- **状态**: ⚠️ 需要验证

### 12. GLM CLI (智谱)
- **配置**: `~/.glm/config.json`
- **状态**: ⚠️ 需要验证

### 13. Kimi CLI (Moonshot)
- **配置**: `~/.kimi/config.toml`
- **状态**: ⚠️ 需要验证

### 14. Qwen CLI (通义千问)
- **配置**: `~/.qwen/settings.json`
- **状态**: ⚠️ 需要验证

### 15. Antigravity
- **配置**: `~/.agent/skills/config.json`
- **状态**: ⚠️ 小众工具，需要验证

### 16. Qoder
- **配置**: `~/.qoder/skills/config.json`
- **状态**: ⚠️ 小众工具，需要验证

### 17. OpenClaw
- **配置**: `~/.openclaw/openclaw.json`
- **状态**: ⚠️ 小众工具，需要验证

## 修正计划

### 高优先级（确定修正）
1. **Cursor**: 统一 MCP 配置，移除 `skills-cursor` 目录方式
2. **Codex**: 需要重新验证，可能不支持 skills 目录

### 中优先级（需要测试验证）
3. VSCode: MCP 配置路径
4. Trae MCP 配置路径
5. Windsurf MCP 配置路径

### 低优先级（国内 CLI）
6. Gemini/GLM/Kimi/Qwen - 这些工具变化快，需要用户反馈验证
