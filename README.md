# AgentSkillsManager

AgentSkillsManager 是一款 macOS 原生应用，用于集中管理 AI Agent（如 Claude Code、OpenAI Codex、GitHub Copilot 等）的 Skills 扩展。通过统一的界面，用户可以浏览、安装、配置和管理各类 AI 工具的扩展功能。

## 功能特性

- **仓库管理**：添加、编辑、同步 GitHub 上的 Skills 仓库
- **Skill 市场**：浏览和安装来自多个仓库的 Skills
- **Agent 配置**：将 Skills 分配给已安装的 AI Agent
- **本地导入**：支持从 ZIP 文件或本地目录导入自定义 Skills
- **主题切换**：支持浅色/深色模式
- **自动检测**：自动扫描本地已安装的 AI Agent

## 支持的 Agent 类型

AgentSkillsManager 目前支持以下 AI Agent：

| Agent | 图标 | 状态 |
|-------|------|------|
| Claude Code | 🤖 | ✅ 支持 |
| OpenAI Codex | 🧠 | ✅ 支持 |
| GitHub Copilot CLI | 👨‍💻 | ✅ 支持 |
| Aider | 🎯 | ✅ 支持 |
| Cursor | ⚡ | ✅ 支持 |
| Gemini CLI | 🔮 | ✅ 支持 |
| GLM CLI | 📊 | ✅ 支持 |
| Kimi CLI | 🌙 | ✅ 支持 |
| Qwen CLI | 🌸 | ✅ 支持 |
| VSCode: | 📝 | ✅ 支持 |
| Trae | 🎨 | ✅ 支持 |
| Windsurf | 🏄 | ✅ 支持 |
| Roo Code | 🦘 | ✅ 支持 |
| Cline | 💻 | ✅ 支持 |
| Codeium | ⚛️ | ✅ 支持 |

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

## 使用指南

### 添加 Skills 仓库

1. 点击侧边栏的 "Skill 仓库"
2. 点击 "添加" 按钮
3. 输入仓库信息：
   - 名称：仓库显示名称
   - URL：GitHub 仓库地址
   - 分支：默认分支（通常为 main）
   - Skill 路径：Skills 所在子目录（可选）

### 安装 Skills

1. 切换到 "Skill 管理" 标签
2. 浏览或搜索感兴趣的 Skills
3. 点击 Skill 查看详情
4. 点击 "安装" 按钮

### 配置 Agent

1. 切换到 "Local Agents" 标签
2. 选择已检测到的 Agent
3. 启用/禁用需要的 Skills
4. 配置自动应用到 Agent

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

## 开发计划

- [ ] 支持更多 AI Agent 类型
- [ ] Skills 评分和评价系统
- [ ] 自动更新检查
- [ ] 批量导入/导出配置
- [ ] 插件系统支持

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
