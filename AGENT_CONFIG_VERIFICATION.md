# Agent 配置路径验证报告

> 生成日期: 2026-03-11
> 用途: 对比代码默认值与官方配置，标记需要修正的项目

## 配置类型说明

- **directory** - 目录扫描型，Skills 创建为子目录
- **file** - 配置文件型，Skills 写入配置文件
- **hybrid** - 混合型，既有配置文件又指定目录

---

## 已验证配置 (✅)

### 1. Claude Code
| 项目 | 代码当前值 | 官方配置 | 状态 |
|------|-----------|---------|------|
| 类型 | directory | directory | ✅ 正确 |
| 路径 | `~/.claude/skills/` | `~/.claude/skills/` | ✅ 正确 |
| 说明 | 固定目录，不可修改 | 官方 Skills 目录 | |

**官方文档**: https://docs.anthropic.com/en/docs/agents-and-tools/claude-code

---

### 2. Cursor
| 项目 | 代码当前值 | 官方配置 | 状态 |
|------|-----------|---------|------|
| 类型 | file | file | ✅ 正确 |
| 路径 | `~/.cursor/mcp.json` | `~/.cursor/mcp.json` | ✅ 正确 |
| 格式 | JSON | JSON | ✅ 正确 |

**官方文档**: https://docs.cursor.com/mcp
**说明**: Cursor 使用 MCP (Model Context Protocol) 配置

---

### 3. Aider
| 项目 | 代码当前值 | 官方配置 | 状态 |
|------|-----------|---------|------|
| 类型 | file | file | ✅ 正确 |
| 路径 | `~/.aider.conf.yml` | `~/.aider.conf.yml` | ✅ 正确 |
| 格式 | YAML | YAML | ✅ 正确 |

**官方文档**: https://aider.chat/docs/config.html
**说明**: Aider 使用 YAML 配置文件，不是 skills 目录

---

## 需要验证/修正的配置 (⚠️)

### 4. OpenAI Codex
| 项目 | 代码当前值 | 可能配置 | 状态 |
|------|-----------|---------|------|
| 类型 | file | file/directory | ⚠️ 待验证 |
| 路径 | `~/.codex/agents.json` | `~/.codex/config.json`? | ⚠️ 不确定 |
| 格式 | JSON | JSON | - |

**问题**:
- Codex 使用 "agents" 概念而非 "skills"
- 可能路径是 `~/.codex/config.json` 而非 `agents.json`
- 也可能是目录 `~/.codex/agents/`

**需要验证**:
- Codex 是否支持自定义 skills?
- 配置文件确切位置和格式

---

### 5. Roo Code (VSCode 扩展)
| 项目 | 代码当前值 | 可能配置 | 状态 |
|------|-----------|---------|------|
| 类型 | file | file/directory | ⚠️ 待验证 |
| 路径 | `~/.roo/mcp.json` | `~/.vscode/settings.json`? | ⚠️ 可能错误 |
| 格式 | JSON | JSON | - |

**问题**:
- Roo Code 是 VSCode 扩展，配置可能在 VSCode: 的 settings.json 中
- 可能使用 `.roorules` 文件或目录
- 不是独立的 MCP 配置

**需要验证**:
- 确切配置位置和格式

---

### 6. Cline (VSCode 扩展)
| 项目 | 代码当前值 | 可能配置 | 状态 |
|------|-----------|---------|------|
| 类型 | file | file/directory | ⚠️ 待验证 |
| 路径 | `~/.cline/mcp.json` | `~/.vscode/settings.json`? | ⚠️ 可能错误 |
| 格式 | JSON | JSON | - |

**问题**:
- Cline 也是 VSCode 扩展，配置可能在 VSCode: 的 settings.json 中
- 可能使用 `.clinerules` 文件

---

### 7. Trae (字节跳动 IDE)
| 项目 | 代码当前值 | 可能配置 | 状态 |
|------|-----------|---------|------|
| 类型 | file | file | ⚠️ 待验证 |
| 路径 | `~/.Trae/mcp.json` | `~/.Trae/mcp.json`? | ⚠️ 推测 |
| 格式 | JSON | JSON | - |

**说明**: 基于 Cursor 同源，可能支持 MCP，但需验证

---

### 8. Windsurf (Codeium)
| 项目 | 代码当前值 | 可能配置 | 状态 |
|------|-----------|---------|------|
| 类型 | file | file | ⚠️ 待验证 |
| 路径 | `~/.codeium/windsurf/mcp_config.json` | ? | ⚠️ 推测 |
| 格式 | JSON | JSON | - |

**说明**: 路径基于 Codeium 品牌推测，需官方验证

---

## 国内 CLI 工具 (待验证)

### 9. Gemini CLI (Google)
| 项目 | 代码当前值 | 状态 |
|------|-----------|------|
| 路径 | `~/.gemini/settings.json` | ⚠️ 推测 |

### 10. GLM CLI (智谱)
| 项目 | 代码当前值 | 状态 |
|------|-----------|------|
| 路径 | `~/.glm/config.json` | ⚠️ 推测 |

### 11. Kimi CLI (Moonshot)
| 项目 | 代码当前值 | 状态 |
|------|-----------|------|
| 路径 | `~/.kimi/config.toml` | ⚠️ 推测 |

### 12. Qwen CLI (阿里通义千问)
| 项目 | 代码当前值 | 状态 |
|------|-----------|------|
| 路径 | `~/.qwen/settings.json` | ⚠️ 推测 |

---

## 小众工具 (待验证)

### 13. Antigravity
| 项目 | 代码当前值 | 状态 |
|------|-----------|------|
| 路径 | `~/.antigravity/mcp.json` | ⚠️ 推测 |

### 14. Qoder
| 项目 | 代码当前值 | 状态 |
|------|-----------|------|
| 路径 | `~/.qoder/mcp.json` | ⚠️ 推测 |

### 15. CodeBuddy
| 项目 | 代码当前值 | 状态 |
|------|-----------|------|
| 路径 | `~/.codebuddy/mcp.json` | ⚠️ 推测 |

### 16. OpenClaw
| 项目 | 代码当前值 | 状态 |
|------|-----------|------|
| 路径 | `~/.openclaw/openclaw.json` | ⚠️ 已修正，待验证 |
| 类型 | file (JSON) | - |
| 说明 | 通过 extraDirs 加载 skills 目录 | - |

---

## GitHub Copilot

### 17. GitHub Copilot CLI
| 项目 | 代码当前值 | 可能配置 | 状态 |
|------|-----------|---------|------|
| 类型 | file | file | ⚠️ 待验证 |
| 路径 | `~/.github/copilot/mcp.json` | ? | ⚠️ 推测 |
| 格式 | JSON | JSON | - |

**问题**:
- GitHub Copilot 通常作为 IDE 扩展，不是独立 CLI
- 可能不支持自定义 MCP 配置

---

## 建议修正

### 高优先级
1. **Codex** - 验证确切配置路径
2. **Roo Code** - 确认是否为 VSCode: settings 而非独立文件
3. **Cline** - 确认是否为 VSCode: settings 而非独立文件

### 中优先级
4. **Trae** - 验证 MCP 支持
5. **Windsurf** - 验证配置路径
6. **国内 CLI** - 收集用户反馈验证

### 低优先级
7. **小众工具** - 等待用户报告或官方文档

---

## 配置类型总结

| Agent | 类型 | 路径 |
|-------|------|------|
| Claude Code | directory | `~/.claude/skills/` |
| Cursor | file | `~/.cursor/mcp.json` |
| Aider | file | `~/.aider.conf.yml` |
| Codex | ? | 待验证 |
| Roo Code | ? | 待验证 |
| Cline | ? | 待验证 |
| Trae | file | `~/.Trae/mcp.json` (推测) |
| Windsurf | file | `~/.codeium/windsurf/mcp_config.json` (推测) |
| Gemini CLI | file | `~/.gemini/settings.json` (推测) |
| GLM CLI | file | `~/.glm/config.json` (推测) |
| Kimi CLI | file | `~/.kimi/config.toml` (推测) |
| Qwen CLI | file | `~/.qwen/settings.json` (推测) |
| OpenClaw | file | `~/.openclaw/openclaw.json` |

---

## 代码更新建议

```swift
// 当前代码中需要修正的 Agent:

// 1. Codex - 路径可能不正确
Agent(
    id: "codex",
    configPath: "~/.codex/agents.json",  // ⚠️ 可能是 ~/.codex/config.json
    configType: .file,
    ...
)

// 2. Roo Code - 可能是 VSCode: 配置而非独立文件
Agent(
    id: "roo-code",
    configPath: "~/.roo/mcp.json",  // ⚠️ 可能在 ~/.vscode/settings.json
    configType: .file,
    ...
)

// 3. Cline - 可能是 VSCode: 配置而非独立文件
Agent(
    id: "cline",
    configPath: "~/.cline/mcp.json",  // ⚠️ 可能在 ~/.vscode/settings.json
    configType: .file,
    ...
)
```

---

## 如何验证配置

1. **查看官方文档** - 访问各工具的官方文档
2. **检查实际文件** - 安装工具后查看实际创建的配置文件
3. **社区反馈** - 收集用户实际使用情况
4. **GitHub Issues** - 查看各工具的 issue 讨论
