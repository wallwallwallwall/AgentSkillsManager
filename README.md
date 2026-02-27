# AgentSkillsManager

AgentSkillsManager 是一款 macOS 原生应用，用于集中管理 AI Agent（如 Claude Code、OpenAI Codex、GitHub Copilot 等）的 Skills 扩展。通过统一的界面，用户可以浏览、安装、配置和管理各类 AI 工具的扩展功能。

## 功能特性

- **仓库管理**：添加、编辑、同步 GitHub 上的 Skills 仓库
- **Skill 市场**：浏览和安装来自多个仓库的 Skills
- **Agent 配置**：将 Skills 分配给已安装的 AI Agent，支持实时同步
- **配置管理**：支持修改 Agent 配置文件路径和编辑配置文件内容
- **本地导入**：支持从 ZIP 文件或本地目录导入自定义 Skills
- **主题切换**：支持浅色/深色模式
- **语言切换**：支持中文/英文界面
- **自动检测**：自动扫描本地已安装的 AI Agent
- **并发同步**：异步仓库同步，不阻塞 UI
- **同名 Skill 支持**：不同仓库的同名 Skill 可同时安装，互不冲突

## 支持的 Agent 类型

AgentSkillsManager 目前支持以下 AI Agent：

| Agent | 图标 | 状态 | 配置方式 | 默认路径 |
|-------|------|------|----------|----------|
| Claude Code | 🤖 | ✅ 支持 | 目录扫描 | `~/.claude/skills/` |
| OpenAI Codex | 🧠 | ✅ 支持 | 目录扫描 | `~/.codex/skills/` |
| GitHub Copilot CLI | 👨‍💻 | ✅ 支持 | MCP 配置 | `~/.copilot/mcp-config.json` |
| Aider | 🎯 | ✅ 支持 | 配置文件 | `~/.aider.conf.yml` |
| Cursor | ⚡ | ✅ 支持 | 目录扫描 | `~/.cursor/skills-cursor/` |
| Gemini CLI | 🔮 | ✅ 支持 | 配置文件 | `~/.gemini/settings.json` |
| GLM CLI | 📊 | ✅ 支持 | 配置文件 | `~/.glm/config.json` |
| Kimi CLI | 🌙 | ✅ 支持 | 配置文件 | `~/.kimi/config.toml` |
| Qwen CLI | 🌸 | ✅ 支持 | 配置文件 | `~/.qwen/settings.json` |
| VSCode: | 📝 | ✅ 支持 | MCP 配置 | `~/.vscode/mcp.json` |
| Trae | 🎨 | ✅ 支持 | MCP 配置 | `~/.Trae/mcp.json` |
| Windsurf | 🏄 | ✅ 支持 | MCP 配置 | `~/.codeium/windsurf/mcp_config.json` |
| Roo Code | 🦘 | ✅ 支持 | 目录扫描 | `~/.roo/rules/` |
| Cline | 💻 | ✅ 支持 | 目录扫描 | `~/.cline/rules/` |
| OpenClaw | 🐾 | ✅ 支持 | JSON 配置 | `~/.openclaw/openclaw.json` |

### Agent 配置方式说明

**目录扫描方式**：这些 Agent 会自动扫描指定目录下的 Skills 文件夹
- Skills 通过符号链接方式管理
- 启用 Skill 时创建链接，禁用时删除链接
- 修改配置路径后会自动同步已启用的 Skills

**MCP 配置方式**：这些 Agent 通过 MCP (Model Context Protocol) 配置文件管理
- Skills 信息写入 JSON 配置文件
- 支持实时更新配置
- 可编辑配置文件内容

**配置文件方式**：这些 Agent 使用各自的配置文件格式
- YAML、TOML 或 JSON 格式
- 支持修改配置文件路径
- 支持编辑配置文件内容

## 同名 Skill 处理机制

AgentSkillsManager 支持从多个仓库安装同名 Skill，通过以下机制避免冲突：

### 安装目录结构

Skill 按照 `仓库名/skill名` 的层级结构存储：

```
~/.agent-skills/installed/
├── anthropics-skills/
│   ├── web-search/
│   └── code-review/
├── openai-skills/
│   ├── web-search/     # 同名但不冲突
│   └── file-analysis/
└── imported/           # 本地导入的 Skills
    └── my-custom-skill/
```

### Agent 配置目录中的链接命名

在 Agent 的配置目录（如 `~/.cursor/skills-cursor/`）中，符号链接使用 `仓库名-技能名` 的格式：

```
~/.cursor/skills-cursor/
├── anthropics-skills-web-search -> ~/.agent-skills/installed/anthropics-skills/web-search
└── openai-skills-web-search -> ~/.agent-skills/installed/openai-skills/web-search
```

这样可以确保同名 Skill 不会互相覆盖。

## 支持的仓库类型

AgentSkillsManager 支持管理以下类型的 Skills 仓库：

### 1. GitHub 远程仓库
- 支持 GitHub 上的公开或私有仓库
- 自动克隆和同步
- 支持指定分支和子目录

**默认仓库示例：**
- `anthropics/skills` - Anthropic 官方 Skills
- `openai/skills` - OpenAI 官方 Skills
- `ComposioHQ/awesome-claude-skills` - Claude Skills 精选集

### 2. 本地目录
- 支持导入本地开发的 Skills
- 支持从 ZIP 文件解压安装
- 自动检测 skill.json 配置文件

### 3. 自定义 Git 仓库
- 支持任意 Git 托管平台（GitLab、Gitee 等）
- 支持 SSH 和 HTTPS 协议
- 可配置同步分支和路径

## 系统要求

- **macOS**: 14.0 或更高版本
- **Xcode**: 16.0 或更高版本（用于开发）
- **Swift**: 5.9 或更高版本

## 安装说明

### 从源码构建

1. 克隆仓库
```bash
git clone https://github.com/wallwallwallwall/AgentSkillsManager.git
cd AgentSkillsManager
```

2. 打开项目
```bash
open AgentSkillsManager.xcodeproj
```

3. 在 Xcode 中构建并运行（Cmd+R）

### 下载预构建版本

访问 [Releases](https://github.com/wallwallwallwall/AgentSkillsManager/releases) 页面下载最新版本。

#### 安装步骤

1. 下载最新版本的 `AgentSkillsManager-v1.0.1.zip`
2. 解压后将 `AgentSkillsManager.app` 拖到 **应用程序** 文件夹
3. 首次运行时，前往 **系统设置 → 隐私与安全性** 中允许打开
4. 应用会自动扫描已安装的 AI Agent

## 使用指南

### 快速开始

```
┌─────────────────────────────────────────────────────────────┐
│  1. 添加 Skills 仓库  →  2. 安装 Skills  →  3. 配置 Agent   │
└─────────────────────────────────────────────────────────────┘
```

### 添加 Skills 仓库

1. 点击侧边栏的 "**Skill 仓库**"
2. 点击 "**添加**" 按钮
3. 输入仓库信息：
   - **名称**：仓库显示名称（如 `anthropics-skills`）
   - **URL**：GitHub 仓库地址（支持自动修正）
     - ✅ 正确格式：`https://github.com/anthropics/skills`
     - ✅ 自动修正：`https://github.com/anthropics/skills/tree/main` → 自动去除 `/tree/...`
   - **分支**：默认分支（通常为 `main`）
   - **Skill 路径**：Skills 所在子目录（可选，如 `skills/`）

**推荐仓库**：
- `anthropics/skills` - Anthropic 官方 Skills
- `openai/skills` - OpenAI 官方 Skills
- `ComposioHQ/awesome-claude-skills` - Claude Skills 精选集

### 安装 Skills

1. 切换到 "**Skill 管理**" 标签
2. 浏览或搜索感兴趣的 Skills（支持多仓库同名 Skill）
3. 点击 Skill 查看详情（描述、作者、仓库来源）
4. 点击 "**安装**" 按钮

> **提示**：不同仓库的同名 Skill 会分别安装，不会冲突

### 配置 Agent

1. 切换到 "**Local Agents**" 标签
2. 查看已自动检测到的 Agent 列表
3. 点击 Agent 展开详情，启用/禁用需要的 Skills
4. Skills 会自动同步到 Agent 的配置目录

#### 修改配置路径

1. 在 Agent 列表中点击配置文件路径
2. 输入新的配置路径（文件夹路径或文件路径）
3. 点击保存，已启用的 Skills 会自动同步到新路径

#### 编辑配置文件

1. 点击 Agent 右侧的 "**配置**" 按钮
2. 在弹出的编辑器中修改配置文件内容
3. 点击保存即可生效

### 本地导入 Skills

支持导入本地开发的 Skills：

1. 点击 "**本地导入**" 按钮
2. 选择 ZIP 文件或本地目录
3. 应用会自动检测 `skill.json` 配置文件
4. 导入后会出现在 "Skill 管理" 列表中

## 项目结构

```
AgentSkillsManager/
├── AgentSkillsManager/
│   ├── AgentSkillsManagerApp.swift    # 应用入口
│   ├── ContentView.swift              # 主界面
│   ├── Models.swift                   # 数据模型
│   └── ...
├── AgentSkillsManager.xcodeproj/      # Xcode 项目
└── README.md                          # 项目说明
```

## 技术栈

- **SwiftUI**：现代化的声明式 UI 框架
- **Swift 5.9**：最新 Swift 语言特性
- **Combine**：响应式编程
- **UserDefaults**：本地数据持久化
- **Git Command Line**：仓库同步管理

## 已知问题修复

### v1.0.1 (最新)
- **修复**: Swift 值类型拷贝导致的 toggle 状态不同步问题
- **修复**: 移除 UI 层多余的 `applyConfigToAgent` 调用，避免配置被覆盖
- **修复**: 使用 `仓库名/skill名` 层级结构区分不同仓库的同名 skill
- **修复**: 使用 `仓库名-技能名` 作为符号链接名避免 Agent 配置目录中的覆盖
- **修复**: 隐藏目录（.git/.github）被错误安装和显示的问题
- **修复**: 添加 `cleanupHiddenSkills` 自动清理已存在的隐藏目录

### v1.0.0
- 初始版本发布
- 支持 15 种 AI Agent
- 支持 Skills 仓库管理、安装、配置

## 开发计划

- [x] 支持更多 AI Agent 类型
- [x] Agent 配置路径自定义
- [x] 配置文件实时编辑
- [x] 同名 Skill 冲突处理
- [ ] Skills 评分和评价系统
- [ ] 自动更新检查
- [ ] 批量导入/导出配置
- [ ] 插件系统支持
- [ ] Windows 版本支持

## 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 致谢

感谢以下项目提供的灵感：
- [Claude Code](https://github.com/anthropics/claude-code)
- [OpenAI Codex](https://github.com/openai/codex)
- [Awesome Claude Skills](https://github.com/ComposioHQ/awesome-claude-skills)

---

**作者**: wallwallwallwall
**GitHub**: https://github.com/wallwallwallwall/AgentSkillsManager
