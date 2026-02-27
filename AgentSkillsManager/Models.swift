import Foundation
import SwiftUI

// MARK: - Skill Repository (GitHub 仓库)
struct SkillRepository: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var url: String
    var branch: String
    var skillPath: String // 如 "/" 或 "/skills"
    var localPath: String
    var lastSyncDate: Date?
    var skills: [RemoteSkill]

    static let `default` = [
        SkillRepository(
            id: UUID(),
            name: "anthropics-skills",
            url: "https://github.com/anthropics/skills",
            branch: "main",
            skillPath: "/skills",
            localPath: "",
            lastSyncDate: nil,
            skills: []
        ),
        SkillRepository(
            id: UUID(),
            name: "openai-skills",
            url: "https://github.com/openai/skills",
            branch: "main",
            skillPath: "/skills",
            localPath: "",
            lastSyncDate: nil,
            skills: []
        ),
        SkillRepository(
            id: UUID(),
            name: "Ai-Agent-Skills",
            url: "https://github.com/skillcreatorai/Ai-Agent-Skills",
            branch: "main",
            skillPath: "/",
            localPath: "",
            lastSyncDate: nil,
            skills: []
        ),
        SkillRepository(
            id: UUID(),
            name: "superpowers",
            url: "https://github.com/obra/superpowers",
            branch: "main",
            skillPath: "/",
            localPath: "",
            lastSyncDate: nil,
            skills: []
        ),
        SkillRepository(
            id: UUID(),
            name: "awesome-claude-skills",
            url: "https://github.com/ComposioHQ/awesome-claude-skills",
            branch: "main",
            skillPath: "/",
            localPath: "",
            lastSyncDate: nil,
            skills: []
        )
    ]
}

// MARK: - Remote Skill (仓库中的 Skill)
struct RemoteSkill: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let author: String
    let version: String
    let license: String
    let platforms: [String]
    let command: String
    let repositoryId: UUID
    let relativePath: String // 在仓库中的路径

    var uniqueId: String { "\(repositoryId.uuidString)_\(id)" }
}

// MARK: - Installed Skill (已安装到本地的 Skill)
struct InstalledSkill: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let author: String
    let version: String
    let license: String
    let platforms: [String]
    let command: String
    let repositoryId: UUID
    let originalRemoteId: String
    let installDate: Date
    let localPath: String // 本地安装路径
    var assignedAgentIds: Set<String> // 分配给哪些 Agent
}

// MARK: - Agent
struct Agent: Identifiable, Codable, Hashable {
    let id: String // 使用类型作为ID，如 "claude-code", "codex"
    var name: String
    var icon: String
    var colorHex: String
    var configPath: String
    var configFormat: ConfigFormat
    var detected: Bool // 是否检测到本地安装
    var enabledSkillIds: Set<String>

    var color: Color {
        Color(hex: colorHex) ?? .blue
    }

    enum ConfigFormat: String, Codable {
        case json, toml, yaml
    }

    // 预设的常见 Agent
    static let presets = [
        Agent(
            id: "claude-code",
            name: "Claude Code",
            icon: "message.circle.fill",
            colorHex: "F97316",
            configPath: "~/.claude/skills/",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "codex",
            name: "OpenAI Codex",
            icon: "terminal.fill",
            colorHex: "10A37F",
            configPath: "~/.codex/skills/",
            configFormat: .toml,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "copilot-cli",
            name: "GitHub Copilot CLI",
            icon: "cpu",
            colorHex: "06B6D4",
            configPath: "~/.copilot/mcp-config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "aider",
            name: "Aider",
            icon: "person.2",
            colorHex: "EC4899",
            configPath: "~/.aider.conf.yml",
            configFormat: .yaml,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "cursor",
            name: "Cursor",
            icon: "cursorarrow",
            colorHex: "3B82F6",
            configPath: "~/.cursor/skills-cursor/",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "gemini-cli",
            name: "Gemini CLI",
            icon: "sparkle",
            colorHex: "8B5CF6",
            configPath: "~/.gemini/settings.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "glm-cli",
            name: "GLM CLI (智谱)",
            icon: "bubble.left.fill",
            colorHex: "22C55E",
            configPath: "~/.glm/config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "kimi-cli",
            name: "Kimi CLI (Moonshot)",
            icon: "moon.fill",
            colorHex: "6366F1",
            configPath: "~/.kimi/config.toml",
            configFormat: .toml,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "qwen-cli",
            name: "Qwen CLI (通义千问)",
            icon: "wand.and.stars",
            colorHex: "F59E0B",
            configPath: "~/.qwen/settings.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "vscode",
            name: "VSCode:",
            icon: "code",
            colorHex: "007ACC",
            configPath: "~/.vscode/mcp.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "cursor-editor",
            name: "Cursor Editor",
            icon: "cursorarrow",
            colorHex: "3B82F6",
            configPath: "~/.cursor/mcp.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "trae",
            name: "Trae",
            icon: "bolt.fill",
            colorHex: "FF6B00",
            configPath: "~/.Trae/mcp.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "antigravity",
            name: "Antigravity",
            icon: "ant.fill",
            colorHex: "6366F1",
            configPath: "~/.agent/skills/config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "qoder",
            name: "Qoder",
            icon: "q.circle.fill",
            colorHex: "8B5CF6",
            configPath: "~/.qoder/skills/config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "windsurf",
            name: "Windsurf",
            icon: "wind",
            colorHex: "06B6D4",
            configPath: "~/.codeium/windsurf/mcp_config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "codebuddy",
            name: "CodeBuddy",
            icon: "person.2.fill",
            colorHex: "10A37F",
            configPath: "~/.codebuddy/skills/config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "roo-code",
            name: "Roo Code",
            icon: "bird.fill",
            colorHex: "D946EF",
            configPath: "~/.roo/rules",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "cline",
            name: "Cline",
            icon: "terminal",
            colorHex: "22D3EE",
            configPath: "~/.cline/rules",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        )
    ]
}

// MARK: - Language Support
enum AppLanguage: String, CaseIterable {
    case chinese = "zh"
    case english = "en"

    var displayName: String {
        switch self {
        case .chinese: return "中文"
        case .english: return "English"
        }
    }
}

// MARK: - Localization
struct L {
    static var language: AppLanguage = .chinese

    static func setLanguage(_ lang: AppLanguage) {
        language = lang
    }

    // Common
    static var ok: String { language == .chinese ? "确定" : "OK" }
    static var cancel: String { language == .chinese ? "取消" : "Cancel" }
    static var close: String { language == .chinese ? "关闭" : "Close" }
    static var save: String { language == .chinese ? "保存" : "Save" }
    static var edit: String { language == .chinese ? "编辑" : "Edit" }
    static var delete: String { language == .chinese ? "删除" : "Delete" }
    static var add: String { language == .chinese ? "添加" : "Add" }
    static var install: String { language == .chinese ? "安装" : "Install" }
    static var uninstall: String { language == .chinese ? "卸载" : "Uninstall" }
    static var installed: String { language == .chinese ? "已安装" : "Installed" }
    static var notInstalled: String { language == .chinese ? "未安装" : "Not Installed" }
    static var sync: String { language == .chinese ? "同步" : "Sync" }
    static var syncing: String { language == .chinese ? "同步中..." : "Syncing..." }
    static var synced: String { language == .chinese ? "已同步" : "Synced" }
    static var notSynced: String { language == .chinese ? "未同步" : "Not Synced" }
    static var syncFailed: String { language == .chinese ? "同步失败" : "Sync Failed" }
    static var copy: String { language == .chinese ? "复制" : "Copy" }
    static var search: String { language == .chinese ? "搜索" : "Search" }
    static var enable: String { language == .chinese ? "启用" : "Enable" }
    static var enabled: String { language == .chinese ? "已启用" : "Enabled" }
    static var disable: String { language == .chinese ? "禁用" : "Disable" }
    static var disabled: String { language == .chinese ? "已禁用" : "Disabled" }
    static var configure: String { language == .chinese ? "配置" : "Configure" }
    static var apply: String { language == .chinese ? "应用" : "Apply" }
    static var open: String { language == .chinese ? "打开" : "Open" }

    // Sidebar
    static var repositoriesTab: String { language == .chinese ? "Skill 仓库" : "Repositories" }
    static var marketplaceTab: String { language == .chinese ? "Skill 管理" : "Marketplace" }
    static var agentsTab: String { language == .chinese ? "Local Agents" : "Local Agents" }
    static var installedTab: String { language == .chinese ? "已安装" : "Installed" }
    static var detectedAgents: String { language == .chinese ? "已检测到 %d 个 Agent" : "Detected %d Agents" }
    static var darkMode: String { language == .chinese ? "深色模式" : "Dark Mode" }
    static var lightMode: String { language == .chinese ? "浅色模式" : "Light Mode" }
    static var languageLabel: String { language == .chinese ? "语言" : "Language" }

    // Repository View
    static var repositoryTitle: String { language == .chinese ? "Skill 仓库" : "Skill Repositories" }
    static var repositorySubtitle: String { language == .chinese ? "%d 个仓库" : "%d Repositories" }
    static var syncAll: String { language == .chinese ? "全部同步" : "Sync All" }
    static var addRepository: String { language == .chinese ? "添加仓库" : "Add Repository" }
    static var editRepository: String { language == .chinese ? "编辑仓库" : "Edit Repository" }
    static var repositoryName: String { language == .chinese ? "仓库名称" : "Repository Name" }
    static var repositoryURL: String { language == .chinese ? "GitHub URL" : "GitHub URL" }
    static var branch: String { language == .chinese ? "分支" : "Branch" }
    static var skillPath: String { language == .chinese ? "Skill 路径" : "Skill Path" }
    static var noRepositories: String { language == .chinese ? "暂无仓库" : "No Repositories" }
    static var noRepositoriesDesc: String { language == .chinese ? "添加 GitHub 仓库来发现更多 Skills" : "Add GitHub repositories to discover more skills" }

    // Marketplace
    static var marketplaceTitle: String { language == .chinese ? "Skill 管理" : "Skill Management" }
    static var marketplaceSubtitle: String { language == .chinese ? "从仓库浏览和安装 Skills" : "Browse and install skills from repositories" }
    static var allRepositories: String { language == .chinese ? "全部仓库" : "All Repositories" }
    static var noSkills: String { language == .chinese ? "暂无 Skills" : "No Skills" }
    static var author: String { language == .chinese ? "作者" : "Author" }
    static var version: String { language == .chinese ? "版本" : "Version" }
    static var license: String { language == .chinese ? "许可证" : "License" }
    static var command: String { language == .chinese ? "命令" : "Command" }
    static var platforms: String { language == .chinese ? "支持的平台" : "Platforms" }
    static var fromRepository: String { language == .chinese ? "来源" : "From" }
    static var skillDetail: String { language == .chinese ? "Skill 详情" : "Skill Detail" }
    static var enableThisSkill: String { language == .chinese ? "启用此 Skill" : "Enable This Skill" }
    static var selectAgents: String { language == .chinese ? "选择要配置的 Local Agents" : "Select Local Agents to Configure" }
    static var noAgentsDetected: String { language == .chinese ? "未检测到 Agent" : "No Agents Detected" }
    static var noAgentsDescription: String { language == .chinese ? "请先安装 AI 工具" : "Please install AI tools first" }
    static var allEnable: String { language == .chinese ? "全部启用" : "Enable All" }
    static var allDisable: String { language == .chinese ? "全部禁用" : "Disable All" }

    // Agents View
    static var agentsTitle: String { language == .chinese ? "Local Agents" : "Local Agents" }
    static var agentsSubtitle: String { language == .chinese ? "管理已安装的 AI 工具" : "Manage installed AI tools" }
    static var rescan: String { language == .chinese ? "重新扫描" : "Rescan" }
    static var noAgents: String { language == .chinese ? "未检测到 Agent" : "No Agents Detected" }
    static var enabledSkills: String { language == .chinese ? "已启用的 Skills" : "Enabled Skills" }
    static var skillsCount: String { language == .chinese ? "%d 个 Skills" : "%d Skills" }
    static var openConfig: String { language == .chinese ? "打开配置" : "Open Config" }
    static var configFormat: String { language == .chinese ? "配置格式" : "Config Format" }
    static var configPath: String { language == .chinese ? "配置文件路径" : "Config Path" }
    static var installPath: String { language == .chinese ? "安装路径" : "Install Path" }
    static var status: String { language == .chinese ? "状态" : "Status" }
    static var detected: String { language == .chinese ? "已检测" : "Detected" }
    static var notDetected: String { language == .chinese ? "未检测" : "Not Detected" }

    // Installed Skills
    static var installedSkillsTitle: String { language == .chinese ? "已安装 Skills" : "Installed Skills" }
    static var installedSkillsSubtitle: String { language == .chinese ? "管理已下载的 Skills 并分配给 Agent" : "Manage downloaded skills and assign to agents" }
    static var noInstalledSkills: String { language == .chinese ? "暂无已安装 Skills" : "No Installed Skills" }
    static var assignedTo: String { language == .chinese ? "已分配给" : "Assigned to" }
    static var installDate: String { language == .chinese ? "安装日期" : "Install Date" }
    static var importFromZIP: String { language == .chinese ? "从 ZIP 导入" : "Import from ZIP" }
    static var importFromDirectory: String { language == .chinese ? "从目录导入" : "Import from Directory" }

    // Import Views
    static var importZIPTitle: String { language == .chinese ? "从 ZIP 安装 Skill" : "Install from ZIP" }
    static var importDirectoryTitle: String { language == .chinese ? "导入本地 Skill" : "Import Local Skill" }
    static var selectZIP: String { language == .chinese ? "选择 ZIP 文件" : "Select ZIP File" }
    static var selectDirectory: String { language == .chinese ? "选择目录" : "Select Directory" }
    static var changeFile: String { language == .chinese ? "更换文件" : "Change File" }
    static var changeDirectory: String { language == .chinese ? "更换目录" : "Change Directory" }
    static var importing: String { language == .chinese ? "正在导入..." : "Importing..." }
    static var skillName: String { language == .chinese ? "名称" : "Name" }

    // Error
    static var error: String { language == .chinese ? "错误" : "Error" }
    static var errorDetails: String { language == .chinese ? "错误详情" : "Error Details" }
    static var possibleCauses: String { language == .chinese ? "可能原因" : "Possible Causes" }
    static var errorNetwork: String { language == .chinese ? "网络连接问题" : "Network connection issue" }
    static var errorNotFound: String { language == .chinese ? "仓库地址不存在" : "Repository not found" }
    static var errorBranch: String { language == .chinese ? "分支名称错误" : "Incorrect branch name" }
    static var errorGit: String { language == .chinese ? "Git 未安装" : "Git not installed" }

    // Toast
    static func syncSuccess(count: Int) -> String {
        language == .chinese ? "同步成功 (\(count) skills)" : "Sync successful (\(count) skills)"
    }
    static func syncAllSuccess(count: Int) -> String {
        language == .chinese ? "成功同步 \(count) 个仓库" : "Successfully synced \(count) repositories"
    }
    static func syncAllWarning(success: Int, failed: Int) -> String {
        language == .chinese ? "同步完成: \(success) 成功, \(failed) 失败" : "Sync completed: \(success) success, \(failed) failed"
    }

    // Additional strings needed for ContentView
    static var manageRepositories: String { language == .chinese ? "管理仓库" : "Manage Repositories" }
    static var addFirstRepository: String { language == .chinese ? "添加第一个仓库" : "Add First Repository" }
    static var unknownRepository: String { language == .chinese ? "未知仓库" : "Unknown Repository" }
    static var skillsInstalled: String { language == .chinese ? "skills" : "skills" }
    static var syncFailedWithName: String { language == .chinese ? "同步失败" : "Sync Failed" }
    static var unknownError: String { language == .chinese ? "未知错误" : "Unknown Error" }
    static var manageEnabledSkills: String { language == .chinese ? "管理启用的 Skills" : "Manage Enabled Skills" }
    static var noSkillsInstalled: String { language == .chinese ? "没有已安装的 Skills" : "No Skills Installed" }
    static var discoverSkills: String { language == .chinese ? "发现技能" : "Discover Skills" }
    static var importLocal: String { language == .chinese ? "导入本地" : "Import Local" }
    static var installedCount: String { language == .chinese ? "已安装" : "Installed" }
    static var noInstalledSkillsDesc: String { language == .chinese ? "从仓库发现并安装技能，或导入已有的技能" : "Discover and install skills from repositories, or import existing skills" }
    static var skillDetails: String { language == .chinese ? "Skill 详情" : "Skill Details" }
    static var supportedPlatforms: String { language == .chinese ? "支持的平台" : "Supported Platforms" }
    static var noAgentsDetectedInstallFirst: String { language == .chinese ? "未检测到 Local Agents，请先安装 AI 工具" : "No Local Agents detected. Please install AI tools first" }
    static var manageSkill: String { language == .chinese ? "管理 Skill" : "Manage Skill" }
    static var zipImportDescription: String { language == .chinese ? "选择包含 Skill 的 ZIP 文件\n将自动解压并安装" : "Select a ZIP file containing the Skill\nIt will be automatically extracted and installed" }
    static var localImportDescription: String { language == .chinese ? "选择包含 Skill 文件的目录\n将复制到安装目录" : "Select a directory containing Skill files\nIt will be copied to the installation directory" }
    static var nameLabel: String { language == .chinese ? "名称:" : "Name:" }
    static var selectZIPFile: String { language == .chinese ? "选择 ZIP 文件" : "Select ZIP File" }
    static var repositoryInfo: String { language == .chinese ? "仓库信息" : "Repository Info" }
    static var examples: String { language == .chinese ? "示例" : "Examples" }
    static var importTitle: String { language == .chinese ? "导入" : "Import" }
    static var selectSkillZIPFile: String { language == .chinese ? "选择 Skill ZIP 文件" : "Select Skill ZIP File" }
    static var selectSkillDirectory: String { language == .chinese ? "选择 Skill 目录" : "Select Skill Directory" }
    static var undetectedAgents: String { language == .chinese ? "未检测到的模型" : "Undetected Agents" }
    static var installedLower: String { language == .chinese ? "已安装" : "installed" }
    static var assignedToAgents: String { language == .chinese ? "已分配给 %d 个模型" : "Assigned to %d agents" }
    static var marketplaceEmptyTitle: String { language == .chinese ? "发现 Skills" : "Discover Skills" }
    static var noRepositoriesMessage: String { language == .chinese ? "您还没有添加任何 Skill 仓库\n请先在「Skill仓库」页面添加仓库" : "You haven't added any skill repositories yet\nPlease add repositories in the Repositories tab" }
    static var goAddRepository: String { language == .chinese ? "前往添加仓库" : "Go Add Repository" }
    static var repositoriesNeedSync: String { language == .chinese ? "您有仓库待同步\n同步后即可浏览和安装 Skills" : "You have repositories waiting to sync\nSync to browse and install skills" }
    static var syncAllNow: String { language == .chinese ? "立即同步所有仓库" : "Sync All Repositories Now" }
    static var noSkillsInRepository: String { language == .chinese ? "该仓库暂无 Skills\n请尝试同步或选择其他仓库" : "No skills in this repository\nTry syncing or select another repository" }
}

// MARK: - View Model
@MainActor
class AppViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var repositories: [SkillRepository] = []
    @Published var installedSkills: [InstalledSkill] = []
    @Published var agents: [Agent] = []

    // UI State
    @Published var selectedTab: Tab = .repositories
    @Published var selectedRepositoryId: UUID?
    @Published var selectedSkillId: String?
    @Published var selectedAgentId: String?
    @Published var searchText: String = ""
    @Published var colorScheme: ColorScheme = .light
    @Published var language: AppLanguage = .chinese {
        didSet {
            L.setLanguage(language)
            saveData()
        }
    }

    // Toast notifications
    @Published var toastMessage: String?
    @Published var toastType: ToastType = .info

    enum ToastType {
        case success, error, info, warning

        var color: Color {
            switch self {
            case .success: return .green
            case .error: return .red
            case .info: return .blue
            case .warning: return .orange
            }
        }

        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }
    }

    func showToast(_ message: String, type: ToastType = .info) {
        toastMessage = message
        toastType = type

        // Auto dismiss after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            withAnimation {
                self?.toastMessage = nil
            }
        }
    }

    enum Tab: String, CaseIterable {
        case repositories
        case marketplace
        case agents
        case installed

        var displayName: String {
            switch self {
            case .repositories: return L.repositoriesTab
            case .marketplace: return L.marketplaceTab
            case .agents: return L.agentsTab
            case .installed: return L.installedTab
            }
        }

        var icon: String {
            switch self {
            case .repositories: return "shippingbox.fill"
            case .marketplace: return "cart.fill"
            case .agents: return "cpu.fill"
            case .installed: return "checkmark.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .repositories: return .blue
            case .marketplace: return .orange
            case .agents: return .green
            case .installed: return .purple
            }
        }
    }

    // MARK: - Computed Properties
    var allRemoteSkills: [RemoteSkill] {
        repositories.flatMap { $0.skills }
    }

    var filteredRemoteSkills: [RemoteSkill] {
        let skills = selectedRepositoryId == nil
            ? allRemoteSkills
            : repositories.first(where: { $0.id == selectedRepositoryId })?.skills ?? []

        if searchText.isEmpty { return skills }
        return skills.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var detectedAgents: [Agent] {
        agents.filter { $0.detected }
    }

    var selectedSkill: InstalledSkill? {
        installedSkills.first { $0.id == selectedSkillId }
    }

    var selectedAgent: Agent? {
        agents.first { $0.id == selectedAgentId }
    }

    // MARK: - Init
    init() {
        loadData()

        // 如果没有仓库或者仓库数量少于默认数量，重新加载默认仓库
        if repositories.isEmpty || repositories.count < SkillRepository.default.count {
            // 合并已保存的和默认的，避免重复
            let existingURLs = Set(repositories.map { $0.url })
            let defaultRepos = SkillRepository.default.filter { !existingURLs.contains($0.url) }
            repositories.append(contentsOf: defaultRepos)
            saveData()
        }

        if agents.isEmpty {
            agents = Agent.presets
        }

        // 检查已安装 skill 的文件是否存在，自动清理无效的 skill
        cleanupMissingSkills()

        // 清理隐藏目录（如 .git, .github 等）
        cleanupHiddenSkills()

        setupNotificationHandlers()
    }

    // MARK: - Cleanup Missing Skills
    /// 检查已安装 skill 的文件是否存在，如果不存在则从列表和 Agent 配置中清理
    /// - Parameter silent: 是否静默处理（不显示提示），默认 false
    func cleanupMissingSkills(silent: Bool = false) {
        let fileManager = FileManager.default
        let homeDir = NSHomeDirectory()
        var removedSkills: [String] = []

        // 找出文件不存在的 skill
        let skillsToRemove = installedSkills.filter { skill in
            let installPath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)
            return !fileManager.fileExists(atPath: installPath)
        }

        guard !skillsToRemove.isEmpty else { return }

        for skill in skillsToRemove {
            print("Skill file missing, auto-removing: \(skill.name)")

            // 从所有 agent 中移除
            for i in agents.indices {
                if agents[i].enabledSkillIds.contains(skill.id) {
                    agents[i].enabledSkillIds.remove(skill.id)
                    // 重新应用配置
                    if agents[i].detected {
                        applyConfigToAgent(agents[i])
                    }
                }
            }

            removedSkills.append(skill.name)
        }

        // 从已安装列表中移除
        installedSkills.removeAll { skill in
            skillsToRemove.contains { $0.id == skill.id }
        }

        saveData()

        // 非静默模式下显示提示
        if !silent && !removedSkills.isEmpty {
            showToast("检测到 \(removedSkills.count) 个 Skill 文件缺失，已自动清理配置", type: .warning)
        }
    }

    // MARK: - Cleanup Hidden Skills
    /// 清理以 . 开头的隐藏目录（如 .git, .github 等）
    func cleanupHiddenSkills() {
        // 找出以 . 开头的隐藏 skill
        let hiddenSkills = installedSkills.filter { skill in
            skill.name.hasPrefix(".")
        }

        guard !hiddenSkills.isEmpty else { return }

        print("[DEBUG] Found \(hiddenSkills.count) hidden skills to clean up: \(hiddenSkills.map { $0.name })")

        for skill in hiddenSkills {
            // 从所有 agent 中移除
            for i in agents.indices {
                if agents[i].enabledSkillIds.contains(skill.id) {
                    agents[i].enabledSkillIds.remove(skill.id)
                    // 重新应用配置
                    if agents[i].detected {
                        applyConfigToAgent(agents[i])
                    }
                }
            }

            // 删除本地文件
            let homeDir = NSHomeDirectory()
            let installPath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)
            try? FileManager.default.removeItem(atPath: installPath)
            print("[DEBUG] Removed hidden skill: \(skill.name)")
        }

        // 从已安装列表中移除
        installedSkills.removeAll { skill in
            skill.name.hasPrefix(".")
        }

        saveData()
        print("[DEBUG] Hidden skills cleaned up successfully")
    }

    private func setupNotificationHandlers() {
        NotificationCenter.default.addObserver(
            forName: .showAddRepository,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.selectedTab = .repositories
            }
        }

        NotificationCenter.default.addObserver(
            forName: .syncAllRepositories,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                await self?.syncAllRepositories()
            }
        }

        NotificationCenter.default.addObserver(
            forName: .rescanAgents,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.scanLocalAgents()
            }
        }

        NotificationCenter.default.addObserver(
            forName: .applyAllConfigs,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.applyAllConfigs()
            }
        }

        // Tab switching
        NotificationCenter.default.addObserver(
            forName: .switchToRepositories,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.selectedTab = .repositories
            }
        }

        NotificationCenter.default.addObserver(
            forName: .switchToMarketplace,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.selectedTab = .marketplace
            }
        }

        NotificationCenter.default.addObserver(
            forName: .switchToAgents,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.selectedTab = .agents
            }
        }

        NotificationCenter.default.addObserver(
            forName: .switchToInstalled,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.selectedTab = .installed
            }
        }
    }

    func performInitialScan() {
        // 使用 Task 将扫描移到后台线程，避免 AttributeGraph 错误
        Task {
            await scanLocalAgentsAsync()
        }
    }

    @MainActor
    private func scanLocalAgentsAsync() async {
        scanLocalAgents()
    }

    // MARK: - Repository Management
    @Published var syncingRepositoryIds: Set<UUID> = []
    @Published var repositorySyncErrors: [UUID: String] = [:]

    // 修复 GitHub URL，将网页 URL 转换为 git URL
    private func fixGitHubURL(_ url: String) -> String {
        // 移除 GitHub 网页 URL 中的 /tree/... 部分
        // 如: https://github.com/openai/skills/tree/main/skills/ -> https://github.com/openai/skills
        if let range = url.range(of: "/tree/") {
            return String(url[..<range.lowerBound])
        }
        return url
    }

    func addRepository(name: String, url: String, branch: String = "main", skillPath: String = "/") {
        let fixedURL = fixGitHubURL(url)
        let repo = SkillRepository(
            id: UUID(),
            name: name,
            url: fixedURL,
            branch: branch,
            skillPath: skillPath,
            localPath: "",
            lastSyncDate: nil,
            skills: []
        )
        repositories.append(repo)
        saveData()
    }

    func deleteRepository(_ repository: SkillRepository) {
        repositories.removeAll { $0.id == repository.id }
        saveData()
    }

    func updateRepository(_ repository: SkillRepository, name: String? = nil, url: String? = nil, branch: String? = nil, skillPath: String? = nil) {
        guard let index = repositories.firstIndex(where: { $0.id == repository.id }) else { return }

        if let name = name, !name.isEmpty {
            repositories[index].name = name
        }
        if let url = url, !url.isEmpty {
            repositories[index].url = fixGitHubURL(url)
        }
        if let branch = branch, !branch.isEmpty {
            repositories[index].branch = branch
        }
        if let skillPath = skillPath {
            repositories[index].skillPath = skillPath
        }

        saveData()
    }

    func syncAllRepositories() async {
        // 使用任务组并发同步所有仓库
        await withTaskGroup(of: (UUID, Result<String, Error>).self) { group in
            for repository in repositories {
                group.addTask {
                    let result = await self.syncRepository(repository)
                    return (repository.id, result)
                }
            }

            var successCount = 0
            var failCount = 0

            for await (_, result) in group {
                switch result {
                case .success:
                    successCount += 1
                case .failure:
                    failCount += 1
                }
            }

            await MainActor.run {
                if failCount == 0 {
                    self.showToast(L.syncAllSuccess(count: successCount), type: .success)
                } else {
                    self.showToast(L.syncAllWarning(success: successCount, failed: failCount), type: .warning)
                }
            }
        }
    }

    // 从仓库拉取 skills
    func syncRepository(_ repository: SkillRepository) async -> Result<String, Error> {
        guard let index = repositories.firstIndex(where: { $0.id == repository.id }) else {
            return .failure(NSError(domain: "Repository not found", code: 404))
        }

        // 更新同步状态
        await MainActor.run {
            syncingRepositoryIds.insert(repository.id)
            repositorySyncErrors.removeValue(forKey: repository.id)
        }

        let fileManager = FileManager.default
        let homeDir = NSHomeDirectory()
        let reposDir = "\(homeDir)/.agent-skills-manager/repos"
        let repoDir = "\(reposDir)/\(repository.name)"

        // 确保 repos 目录存在
        if !fileManager.fileExists(atPath: reposDir) {
            try? fileManager.createDirectory(atPath: reposDir, withIntermediateDirectories: true)
        }

        // 克隆或拉取仓库
        let task = Process()
        task.launchPath = "/bin/bash"

        // 检查目录是否存在且是有效的 git 仓库
        let gitDir = "\(repoDir)/.git"
        let isValidGitRepo = fileManager.fileExists(atPath: gitDir)
        var isNewClone = !fileManager.fileExists(atPath: repoDir)

        // 如果目录存在但不是有效的 git 仓库，删除它
        if fileManager.fileExists(atPath: repoDir) && !isValidGitRepo {
            print("Directory exists but is not a valid git repo, removing: \(repoDir)")
            do {
                try fileManager.removeItem(atPath: repoDir)
                isNewClone = true  // 删除后需要重新克隆
                print("Successfully removed invalid repo directory")
            } catch {
                print("Failed to remove directory: \(error)")
            }
        }

        return await withCheckedContinuation { continuation in
            Task {
                do {
                    var cloneSuccess = false
                    var finalErrorMessage = ""

                    if isNewClone || !isValidGitRepo {
                        // 简化 git clone 命令
                        task.arguments = ["-c", "git clone --depth 1 '\(repository.url)' '\(repoDir)'"]

                        print("[GIT] Cloning \(repository.url) to \(repoDir)")
                        let result = await self.runProcessAsync(task)
                        print("[GIT] Clone status: \(result.terminationStatus)")

                        if result.terminationStatus == 0 {
                            cloneSuccess = true
                        } else {
                            let errorMsg = result.stderr
                            let outputMsg = result.stdout
                            finalErrorMessage = "Clone failed: \(errorMsg.isEmpty ? outputMsg : errorMsg)"
                            print("[GIT ERROR] \(finalErrorMessage)")

                            // 清理失败的部分克隆
                            try? fileManager.removeItem(atPath: repoDir)
                        }
                    } else {
                        // 已存在，执行 git pull
                        task.arguments = ["-c", "cd '\(repoDir)' && git pull"]

                        print("[GIT] Pulling \(repository.name)")
                        let result = await self.runProcessAsync(task)
                        print("[GIT] Pull status: \(result.terminationStatus)")

                        cloneSuccess = result.terminationStatus == 0
                        if !cloneSuccess {
                            let errorMsg = result.stderr
                            let outputMsg = result.stdout
                            finalErrorMessage = "Pull failed: \(errorMsg.isEmpty ? outputMsg : errorMsg)"
                            print("[GIT ERROR] \(finalErrorMessage)")
                        }
                    }

                    _ = await MainActor.run {
                        syncingRepositoryIds.remove(repository.id)
                    }

                    if cloneSuccess {
                        // 在后台线程解析 skills，避免阻塞 UI
                        let skillsPath = "\(repoDir)\(repository.skillPath)"
                        let repoId = repository.id
                        let skills = await Task.detached(priority: .userInitiated) {
                            return Self.parseSkillsFromDirectory(skillsPath, repositoryId: repoId)
                        }.value

                        await MainActor.run {
                            repositories[index].skills = skills
                            repositories[index].localPath = repoDir
                            repositories[index].lastSyncDate = Date()
                            saveData()
                        }

                        let message = isNewClone ? "克隆成功 (\(skills.count) 个 skills)" : "更新成功 (\(skills.count) 个 skills)"
                        continuation.resume(returning: .success(message))
                    } else {
                        _ = await MainActor.run {
                            repositorySyncErrors[repository.id] = finalErrorMessage
                        }
                        continuation.resume(returning: .failure(NSError(domain: finalErrorMessage, code: 500)))
                    }
                } catch {
                    _ = await MainActor.run {
                        syncingRepositoryIds.remove(repository.id)
                        repositorySyncErrors[repository.id] = error.localizedDescription
                    }
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }

    /// 进程执行结果
    struct ProcessResult {
        let terminationStatus: Int32
        let stdout: String
        let stderr: String
    }

    /// 异步执行 Process，不阻塞线程，带超时（默认60秒）
    /// 返回终止状态和输出内容
    private func runProcessAsync(_ process: Process, timeout: TimeInterval = 60) async -> ProcessResult {
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        return await withCheckedContinuation { continuation in
            let stdoutData = NSMutableData()
            let stderrData = NSMutableData()

            // 设置输出读取句柄
            outputPipe.fileHandleForReading.readabilityHandler = { handle in
                let data = handle.availableData
                if !data.isEmpty {
                    stdoutData.append(data)
                }
            }

            errorPipe.fileHandleForReading.readabilityHandler = { handle in
                let data = handle.availableData
                if !data.isEmpty {
                    stderrData.append(data)
                }
            }

            // 设置超时定时器
            let timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { _ in
                process.terminate()
                outputPipe.fileHandleForReading.readabilityHandler = nil
                errorPipe.fileHandleForReading.readabilityHandler = nil
                let stdout = String(data: stdoutData as Data, encoding: .utf8) ?? ""
                let stderr = String(data: stderrData as Data, encoding: .utf8) ?? ""
                print("Process timed out after \(timeout) seconds")
                continuation.resume(returning: ProcessResult(terminationStatus: -2, stdout: stdout, stderr: stderr))
            }

            process.terminationHandler = { task in
                timer.invalidate()

                // 关闭管道并读取剩余数据
                outputPipe.fileHandleForReading.readabilityHandler = nil
                errorPipe.fileHandleForReading.readabilityHandler = nil

                let finalStdout = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let finalStderr = errorPipe.fileHandleForReading.readDataToEndOfFile()
                stdoutData.append(finalStdout)
                stderrData.append(finalStderr)

                let stdout = String(data: stdoutData as Data, encoding: .utf8) ?? ""
                let stderr = String(data: stderrData as Data, encoding: .utf8) ?? ""

                continuation.resume(returning: ProcessResult(terminationStatus: task.terminationStatus, stdout: stdout, stderr: stderr))
            }

            do {
                try process.run()
            } catch {
                timer.invalidate()
                outputPipe.fileHandleForReading.readabilityHandler = nil
                errorPipe.fileHandleForReading.readabilityHandler = nil
                continuation.resume(returning: ProcessResult(terminationStatus: -1, stdout: "", stderr: error.localizedDescription))
            }
        }
    }

    nonisolated private static func parseSkillsFromDirectory(_ path: String, repositoryId: UUID, maxDepth: Int = 3) -> [RemoteSkill] {
        let fileManager = FileManager.default
        var skills: [RemoteSkill] = []

        print("[DEBUG] parseSkillsFromDirectory: path=\(path), maxDepth=\(maxDepth)")

        // 扫描指定的 path 目录及其直接子目录
        // 结构示例：/skills/.curated/web-search.md
        // - /skills/ (depth 0) - 不扫描这里的文件
        // - /skills/.curated/ (depth 1) - 扫描这里的 .md 文件

        var scanPaths: [(String, String)] = [(path, "")]

        // 使用队列进行广度优先扫描
        var queue: [(path: String, relativePath: String, depth: Int)] = [(path, "", 0)]
        var processedPaths = Set<String>()

        while !queue.isEmpty {
            let current = queue.removeFirst()

            // 避免重复处理
            if processedPaths.contains(current.relativePath) {
                continue
            }
            processedPaths.insert(current.relativePath)

            guard let contents = try? fileManager.contentsOfDirectory(atPath: current.path) else {
                continue
            }

            print("[DEBUG] Scanning directory: \(current.path), depth: \(current.depth), items: \(contents.count)")

            for item in contents {
                // 过滤常见非 skill 目录，但允许以 . 开头的 skill 目录（如 .curated, .system）
                if item == "node_modules" || item == "vendor" || item == ".git" || item == ".github" || item == ".gitignore" {
                    continue
                }

                let itemPath = "\(current.path)/\(item)"
                let currentRelativePath = current.relativePath.isEmpty ? item : "\(current.relativePath)/\(item)"

                var isDirectory: ObjCBool = false
                let exists = fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory)

                guard exists else { continue }

                print("[DEBUG] Found item: \(item), isDir: \(isDirectory.boolValue), depth: \(current.depth)")

                if isDirectory.boolValue {
                    // 情况1：目录下有 skill.json/README.md/SKILL.md → 这是一个 skill
                    let isSkill = isSkillDirectory(at: itemPath)
                    print("[DEBUG]   isSkillDirectory: \(isSkill)")
                    if isSkill {
                        if let skill = parseSkillConfig(at: itemPath, name: item, repositoryId: repositoryId, relativePath: currentRelativePath) {
                            print("[DEBUG]   -> Added skill: \(skill.name)")
                            skills.append(skill)
                        }
                    } else if current.depth < 2 {
                        // 情况2：递归扫描子目录（最多2层）
                        // 对于 openai/skills/.curated/cloudflare-deploy 这样的结构
                        print("[DEBUG]   -> Queue subdir for scanning")
                        queue.append((path: itemPath, relativePath: currentRelativePath, depth: current.depth + 1))
                    }
                } else if item.hasSuffix(".md") && !item.hasPrefix(".") && current.depth >= 1 && current.depth <= 2 {
                    // 情况3：.md 文件本身就是一个 skill（如 web-search.md）
                    // 处理第1-2层子目录中的 .md 文件
                    // 如 .curated/web-search.md 或 .curated/subdir/doc.md
                    let lowercasedItem = item.lowercased()
                    if lowercasedItem == "readme.md" || lowercasedItem == "license.md" || lowercasedItem == "contributing.md" {
                        continue
                    }
                    let skillName = String(item.dropLast(3)) // 去掉 .md
                    if let skill = parseMarkdownSkill(at: itemPath, name: skillName, repositoryId: repositoryId, relativePath: currentRelativePath) {
                        skills.append(skill)
                    }
                }
            }
        }

        print("[DEBUG] Total skills found: \(skills.count)")
        return skills
    }

    /// 检查目录是否是一个 skill 目录（包含 skill.json 或 README.md）
    nonisolated private static func isSkillDirectory(at path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: "\(path)/skill.json")
            || fileManager.fileExists(atPath: "\(path)/README.md")
            || fileManager.fileExists(atPath: "\(path)/SKILL.md")
    }

    /// 解析 markdown 文件作为 skill
    nonisolated private static func parseMarkdownSkill(at path: String, name: String, repositoryId: UUID, relativePath: String) -> RemoteSkill? {
        let fileManager = FileManager.default

        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return nil
        }

        // 提取标题（第一行 # 开头的）
        var description = "Skill: \(name)"
        let lines = content.components(separatedBy: .newlines)
        if let titleLine = lines.first(where: { $0.hasPrefix("# ") }) {
            description = titleLine.replacingOccurrences(of: "# ", with: "").trimmingCharacters(in: .whitespaces)
        } else if let firstLine = lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) {
            description = firstLine.trimmingCharacters(in: .whitespaces)
        }

        return RemoteSkill(
            id: relativePath,
            name: name,
            description: description,
            author: "Unknown",
            version: "1.0.0",
            license: "Unknown",
            platforms: ["Claude Code"],
            command: "/\(name)",
            repositoryId: repositoryId,
            relativePath: relativePath
        )
    }

    nonisolated private static func parseSkillConfig(at path: String, name: String, repositoryId: UUID, relativePath: String? = nil) -> RemoteSkill? {
        let fileManager = FileManager.default
        let actualRelativePath = relativePath ?? name

        // 尝试读取 skill.json
        let skillJsonPath = "\(path)/skill.json"
        let packageJsonPath = "\(path)/package.json"

        var config: [String: Any]?

        if fileManager.fileExists(atPath: skillJsonPath),
           let data = try? Data(contentsOf: URL(fileURLWithPath: skillJsonPath)),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = json
        } else if fileManager.fileExists(atPath: packageJsonPath),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: packageJsonPath)),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = json
        }

        // 如果没有配置文件，从 README.md 或 SKILL.md 或目录名推断
        if config == nil {
            return Self.createSkillFromDirectory(path: path, name: name, repositoryId: repositoryId, relativePath: actualRelativePath)
        }

        guard let config = config else { return nil }

        return RemoteSkill(
            id: config["id"] as? String ?? actualRelativePath,
            name: config["name"] as? String ?? name,
            description: config["description"] as? String ?? "No description",
            author: config["author"] as? String ?? "Unknown",
            version: config["version"] as? String ?? "1.0.0",
            license: config["license"] as? String ?? "Unknown",
            platforms: config["platforms"] as? [String] ?? ["Claude Code"],
            command: config["command"] as? String ?? "/\(name)",
            repositoryId: repositoryId,
            relativePath: actualRelativePath
        )
    }

    nonisolated private static func createSkillFromDirectory(path: String, name: String, repositoryId: UUID, relativePath: String? = nil) -> RemoteSkill? {
        let fileManager = FileManager.default
        let actualRelativePath = relativePath ?? name

        // 尝试读取 README.md 或 SKILL.md
        let readmePath = "\(path)/README.md"
        let skillMdPath = "\(path)/SKILL.md"
        var description = "Skill: \(name)"

        let mdPath = fileManager.fileExists(atPath: readmePath) ? readmePath : skillMdPath

        if fileManager.fileExists(atPath: mdPath),
           let content = try? String(contentsOfFile: mdPath, encoding: .utf8) {
            // 提取第一行作为描述
            let lines = content.components(separatedBy: .newlines)
            if let firstLine = lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) {
                description = firstLine.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: .whitespaces)
            }
        }

        return RemoteSkill(
            id: actualRelativePath,
            name: name,
            description: description,
            author: "Unknown",
            version: "1.0.0",
            license: "Unknown",
            platforms: ["Claude Code"],
            command: "/\(name)",
            repositoryId: repositoryId,
            relativePath: actualRelativePath
        )
    }

    // MARK: - Skill Installation
    func installSkill(_ skill: RemoteSkill) {
        guard !installedSkills.contains(where: { $0.originalRemoteId == skill.id && $0.repositoryId == skill.repositoryId }) else {
            return // 已安装
        }

        // 找到对应的仓库
        guard let repository = repositories.first(where: { $0.id == skill.repositoryId }),
              !repository.localPath.isEmpty else {
            showToast("请先同步仓库后再安装", type: .warning)
            return
        }

        let fileManager = FileManager.default
        let homeDir = NSHomeDirectory()

        // 源路径：仓库中的 skill 目录
        let sourcePath = "\(repository.localPath)\(repository.skillPath)/\(skill.relativePath)"

        // 目标路径：本地安装目录（使用 仓库名/skill名 的层级结构区分不同仓库的同名skill）
        let sanitizedRepoName = repository.name.replacingOccurrences(of: "/", with: "-")
        let installDir = "\(homeDir)/.agent-skills/installed/\(sanitizedRepoName)/\(skill.name)"
        let localPath = "~/.agent-skills/installed/\(sanitizedRepoName)/\(skill.name)"

        // 确保安装目录存在
        do {
            try fileManager.createDirectory(atPath: installDir, withIntermediateDirectories: true)
        } catch {
            showToast("创建安装目录失败: \(error.localizedDescription)", type: .error)
            return
        }

        // 复制文件
        do {
            var isSourceDirectory: ObjCBool = false
            let sourceExists = fileManager.fileExists(atPath: sourcePath, isDirectory: &isSourceDirectory)

            guard sourceExists else {
                showToast("源文件不存在: \(sourcePath)", type: .error)
                return
            }

            if isSourceDirectory.boolValue {
                // 情况1：sourcePath 是目录，遍历复制内容
                let contents = try fileManager.contentsOfDirectory(atPath: sourcePath)
                for item in contents {
                    // 跳过隐藏文件和目录（如 .git, .github 等）
                    if item.hasPrefix(".") {
                        continue
                    }

                    let sourceItem = "\(sourcePath)/\(item)"
                    let destItem = "\(installDir)/\(item)"

                    var isDirectory: ObjCBool = false
                    if fileManager.fileExists(atPath: sourceItem, isDirectory: &isDirectory) {
                        if isDirectory.boolValue {
                            // 递归复制目录
                            try? fileManager.copyItem(atPath: sourceItem, toPath: destItem)
                        } else {
                            // 复制文件
                            if fileManager.fileExists(atPath: destItem) {
                                try? fileManager.removeItem(atPath: destItem)
                            }
                            try fileManager.copyItem(atPath: sourceItem, toPath: destItem)
                        }
                    }
                }
            } else {
                // 情况2：sourcePath 是文件（如 .md 文件），直接复制
                let destFile = "\(installDir)/\(skill.name).md"
                if fileManager.fileExists(atPath: destFile) {
                    try? fileManager.removeItem(atPath: destFile)
                }
                try fileManager.copyItem(atPath: sourcePath, toPath: destFile)
            }
            showToast("Skill 文件已复制", type: .info)
        } catch {
            showToast("复制文件失败: \(error.localizedDescription)", type: .error)
            return
        }

        let installed = InstalledSkill(
            id: UUID().uuidString,
            name: skill.name,
            description: skill.description,
            author: skill.author,
            version: skill.version,
            license: skill.license,
            platforms: skill.platforms,
            command: skill.command,
            repositoryId: skill.repositoryId,
            originalRemoteId: skill.id,
            installDate: Date(),
            localPath: localPath,
            assignedAgentIds: []
        )
        installedSkills.append(installed)
        saveData()

        showToast("已安装 Skill: \(skill.name)", type: .success)
    }

    func uninstallSkill(_ skill: InstalledSkill) {
        let fileManager = FileManager.default
        let homeDir = NSHomeDirectory()

        // 1. 删除安装目录的文件
        let installPath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)
        if fileManager.fileExists(atPath: installPath) {
            do {
                try fileManager.removeItem(atPath: installPath)
                print("Deleted installed skill files at: \(installPath)")
            } catch {
                print("Failed to delete installed skill files: \(error)")
                showToast("删除安装文件失败: \(error.localizedDescription)", type: .error)
                return
            }
        }

        // 2. 删除仓库源文件（如果存在）
        if let repository = repositories.first(where: { $0.id == skill.repositoryId }),
           !repository.localPath.isEmpty {
            // 尝试通过 originalRemoteId 找到源 skill 并删除
            let sourceSkillPath = "\(repository.localPath)\(repository.skillPath)/\(skill.originalRemoteId)"
            if fileManager.fileExists(atPath: sourceSkillPath) {
                do {
                    try fileManager.removeItem(atPath: sourceSkillPath)
                    print("Deleted source skill files at: \(sourceSkillPath)")
                } catch {
                    print("Failed to delete source skill files: \(error)")
                    // 源文件删除失败不阻止卸载流程
                }
            }

            // 同时尝试通过 skill 名称查找并删除
            let sourceSkillPathByName = "\(repository.localPath)\(repository.skillPath)/\(skill.name)"
            if sourceSkillPathByName != sourceSkillPath,
               fileManager.fileExists(atPath: sourceSkillPathByName) {
                do {
                    try fileManager.removeItem(atPath: sourceSkillPathByName)
                    print("Deleted source skill files by name at: \(sourceSkillPathByName)")
                } catch {
                    print("Failed to delete source skill files by name: \(error)")
                }
            }
        }

        // 3. 从所有 agent 中移除并重新应用配置
        for i in agents.indices {
            if agents[i].enabledSkillIds.contains(skill.id) {
                agents[i].enabledSkillIds.remove(skill.id)
                // 重新应用配置以更新配置文件
                if agents[i].detected {
                    applyConfigToAgent(agents[i])
                }
            }
        }

        installedSkills.removeAll { $0.id == skill.id }
        saveData()

        showToast("已卸载 Skill: \(skill.name)", type: .info)
    }

    func isSkillInstalled(_ skill: RemoteSkill) -> Bool {
        installedSkills.contains { $0.originalRemoteId == skill.id && $0.repositoryId == skill.repositoryId }
    }

    // MARK: - Import Skills
    // 异步版本的目录导入
    func importSkillFromDirectoryAsync(_ sourcePath: String, name: String) async -> Result<InstalledSkill, Error> {
        return importSkillFromDirectory(sourcePath, name: name)
    }

    func importSkillFromDirectory(_ sourcePath: String, name: String) -> Result<InstalledSkill, Error> {
        let fileManager = FileManager.default
        let homeDir = NSHomeDirectory()

        // 目标路径：本地导入的 skill 使用 imported 作为仓库名
        let installDir = "\(homeDir)/.agent-skills/installed/imported/\(name)"
        let localPath = "~/.agent-skills/installed/imported/\(name)"

        // 检查是否已存在（检查相同仓库+skill名）
        if installedSkills.contains(where: { $0.name == name && $0.localPath.contains("/imported/") }) {
            return .failure(NSError(domain: "Skill '\(name)' 已存在", code: 409))
        }

        // 确保安装目录存在
        do {
            try fileManager.createDirectory(atPath: installDir, withIntermediateDirectories: true)
        } catch {
            return .failure(error)
        }

        // 复制文件
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: sourcePath)
            for item in contents {
                let sourceItem = "\(sourcePath)/\(item)"
                let destItem = "\(installDir)/\(item)"

                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: sourceItem, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        try? fileManager.copyItem(atPath: sourceItem, toPath: destItem)
                    } else {
                        if fileManager.fileExists(atPath: destItem) {
                            try? fileManager.removeItem(atPath: destItem)
                        }
                        try fileManager.copyItem(atPath: sourceItem, toPath: destItem)
                    }
                }
            }
        } catch {
            return .failure(error)
        }

        // 尝试读取 skill.json 获取信息
        let skillJsonPath = "\(installDir)/skill.json"
        var description = "导入的 Skill: \(name)"
        var author = "Unknown"
        var version = "1.0.0"
        var license = "Unknown"
        var command = "/\(name)"

        if let data = try? Data(contentsOf: URL(fileURLWithPath: skillJsonPath)),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            description = json["description"] as? String ?? description
            author = json["author"] as? String ?? author
            version = json["version"] as? String ?? version
            license = json["license"] as? String ?? license
            command = json["command"] as? String ?? command
        }

        let installed = InstalledSkill(
            id: UUID().uuidString,
            name: name,
            description: description,
            author: author,
            version: version,
            license: license,
            platforms: ["Claude Code"],
            command: command,
            repositoryId: UUID(), // 使用随机UUID表示本地导入
            originalRemoteId: "local-\(name)",
            installDate: Date(),
            localPath: localPath,
            assignedAgentIds: []
        )
        installedSkills.append(installed)
        saveData()

        showToast("已导入 Skill: \(name)", type: .success)

        return .success(installed)
    }

    // 异步版本的 ZIP 导入
    func importSkillFromZIPAsync(_ zipPath: String) async -> Result<InstalledSkill, Error> {
        return importSkillFromZIP(zipPath)
    }

    func importSkillFromZIP(_ zipPath: String) -> Result<InstalledSkill, Error> {
        let fileManager = FileManager.default
        let homeDir = NSHomeDirectory()

        // 创建临时解压目录
        let tempDir = "\(homeDir)/.agent-skills-manager/temp/\(UUID().uuidString)"

        do {
            try fileManager.createDirectory(atPath: tempDir, withIntermediateDirectories: true)

            // 解压ZIP文件
            let task = Process()
            task.launchPath = "/usr/bin/unzip"
            task.arguments = ["-q", zipPath, "-d", tempDir]

            try task.run()
            task.waitUntilExit()

            if task.terminationStatus != 0 {
                return .failure(NSError(domain: "ZIP解压失败", code: Int(task.terminationStatus)))
            }

            // 查找解压后的目录
            let contents = try fileManager.contentsOfDirectory(atPath: tempDir)
            var skillDir = tempDir

            // 如果ZIP包含一个根目录，进入该目录
            if contents.count == 1 {
                let item = contents[0]
                var isDir: ObjCBool = false
                let itemPath = "\(tempDir)/\(item)"
                if fileManager.fileExists(atPath: itemPath, isDirectory: &isDir), isDir.boolValue {
                    skillDir = itemPath
                }
            }

            // 使用ZIP文件名作为skill名称
            let zipName = (zipPath as NSString).lastPathComponent
            let skillName = zipName.replacingOccurrences(of: ".zip", with: "")

            // 导入skill
            let result = importSkillFromDirectory(skillDir, name: skillName)

            // 清理临时目录
            try? fileManager.removeItem(atPath: tempDir)

            return result
        } catch {
            try? fileManager.removeItem(atPath: tempDir)
            return .failure(error)
        }
    }

    // MARK: - Agent Management
    func scanLocalAgents() {
        let fileManager = FileManager.default
        let homeDir = NSHomeDirectory()

        for i in agents.indices {
            var found = false
            let configPath = agents[i].configPath.replacingOccurrences(of: "~", with: homeDir)

            // 1. 检查配置文件是否存在
            if fileManager.fileExists(atPath: configPath) {
                found = true
            }

            // 2. 检查命令行工具是否存在（which command）
            if !found {
                let commandName = commandNameForAgent(agents[i].id)
                found = checkCommandExists(commandName)
            }

            // 3. 对于某些工具，检查其他标志性文件
            if !found {
                found = checkAlternativePaths(for: agents[i], homeDir: homeDir)
            }

            agents[i].detected = found
        }

        saveData()
    }

    private func commandNameForAgent(_ agentId: String) -> String {
        switch agentId {
        case "claude-code": return "claude"
        case "codex": return "codex"
        case "copilot-cli": return "gh"
        case "aider": return "aider"
        case "cursor": return "cursor"  // Cursor 可能没有 CLI
        case "gemini-cli": return "gemini"
        case "glm-cli": return "glm"
        case "kimi-cli": return "kimi"
        case "qwen-cli": return "qwen"
        default: return agentId
        }
    }

    private func checkCommandExists(_ command: String) -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/which"
        task.arguments = [command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
            task.waitUntilExit()
            return task.terminationStatus == 0
        } catch {
            return false
        }
    }

    private func checkAlternativePaths(for agent: Agent, homeDir: String) -> Bool {
        let fileManager = FileManager.default

        switch agent.id {
        case "claude-code":
            // 检查 ~/.claude/ 目录或其他标志性文件
            let alternativePaths = [
                "~/.claude",
                "~/.config/claude",
                "/usr/local/bin/claude"
            ]
            for path in alternativePaths {
                let expandedPath = path.replacingOccurrences(of: "~", with: homeDir)
                if fileManager.fileExists(atPath: expandedPath) {
                    return true
                }
            }

        case "codex":
            let alternativePaths = [
                "~/.codex",
                "~/.config/codex"
            ]
            for path in alternativePaths {
                let expandedPath = path.replacingOccurrences(of: "~", with: homeDir)
                if fileManager.fileExists(atPath: expandedPath) {
                    return true
                }
            }

        case "copilot-cli":
            // 检查 gh copilot 扩展
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["-c", "gh copilot --version 2>/dev/null"]

            do {
                try task.run()
                task.waitUntilExit()
                return task.terminationStatus == 0
            } catch {
                // 检查 ~/.local/share/gh/extensions/gh-copilot/
                let copilotPath = "~/.local/share/gh/extensions/gh-copilot".replacingOccurrences(of: "~", with: homeDir)
                return fileManager.fileExists(atPath: copilotPath)
            }

        case "aider":
            let alternativePaths = [
                "~/.aider"
            ]
            for path in alternativePaths {
                let expandedPath = path.replacingOccurrences(of: "~", with: homeDir)
                if fileManager.fileExists(atPath: expandedPath) {
                    return true
                }
            }

        case "cursor":
            // Cursor 通常是 GUI 应用
            let cursorPaths = [
                "/Applications/Cursor.app",
                "~/Applications/Cursor.app"
            ]
            for path in cursorPaths {
                let expandedPath = path.replacingOccurrences(of: "~", with: homeDir)
                if fileManager.fileExists(atPath: expandedPath) {
                    return true
                }
            }

        case "vscode":
            let vscodePaths = [
                "/Applications/Visual Studio Code:.app",
                "~/Applications/Visual Studio Code:.app",
                "/Applications/VSCode:.app",
                "~/Applications/VSCode:.app"
            ]
            for path in vscodePaths {
                let expandedPath = path.replacingOccurrences(of: "~", with: homeDir)
                if fileManager.fileExists(atPath: expandedPath) {
                    return true
                }
            }

        case "cursor-editor":
            // Cursor Editor 配置文件检测
            let cursorEditorPath = "~/.cursor/skills".replacingOccurrences(of: "~", with: homeDir)
            if fileManager.fileExists(atPath: cursorEditorPath) {
                return true
            }

        case "trae":
            let traePaths = [
                "/Applications/Trae.app",
                "~/Applications/Trae.app"
            ]
            for path in traePaths {
                let expandedPath = path.replacingOccurrences(of: "~", with: homeDir)
                if fileManager.fileExists(atPath: expandedPath) {
                    return true
                }
            }

        case "windsurf":
            let windsurfPaths = [
                "/Applications/Windsurf.app",
                "~/Applications/Windsurf.app"
            ]
            for path in windsurfPaths {
                let expandedPath = path.replacingOccurrences(of: "~", with: homeDir)
                if fileManager.fileExists(atPath: expandedPath) {
                    return true
                }
            }

        default:
            // 对于其他编辑器，检查配置文件目录是否存在
            let configDir = (agent.configPath as NSString).deletingLastPathComponent
            let expandedConfigDir = configDir.replacingOccurrences(of: "~", with: homeDir)
            if fileManager.fileExists(atPath: expandedConfigDir) {
                return true
            }
            break
        }

        return false
    }

    func toggleSkillForAgent(_ skill: InstalledSkill, agent: Agent) {
        if let agentIndex = agents.firstIndex(where: { $0.id == agent.id }) {
            if agents[agentIndex].enabledSkillIds.contains(skill.id) {
                agents[agentIndex].enabledSkillIds.remove(skill.id)
            } else {
                agents[agentIndex].enabledSkillIds.insert(skill.id)
            }
            saveData()

            // 使用更新后的 agent 对象
            let updatedAgent = agents[agentIndex]

            // 更新 installed skill 的分配记录
            if let skillIndex = installedSkills.firstIndex(where: { $0.id == skill.id }) {
                if installedSkills[skillIndex].assignedAgentIds.contains(agent.id) {
                    installedSkills[skillIndex].assignedAgentIds.remove(agent.id)
                } else {
                    installedSkills[skillIndex].assignedAgentIds.insert(agent.id)
                }
                saveData()
            }

            // 实时更新 Agent 配置文件 - 使用更新后的 agent
            applyConfigToAgent(updatedAgent)
        }
    }

    func isSkillEnabledForAgent(_ skill: InstalledSkill, agent: Agent) -> Bool {
        agent.enabledSkillIds.contains(skill.id)
    }

    // 应用配置到 Agent - 根据 Agent 类型使用不同方式
    func applyConfigToAgent(_ agent: Agent) {
        let enabledSkills = installedSkills.filter { agent.enabledSkillIds.contains($0.id) }

        print("[DEBUG] === applyConfigToAgent ===")
        print("[DEBUG] Agent: \(agent.name) (id: \(agent.id))")
        print("[DEBUG] Agent.enabledSkillIds: \(agent.enabledSkillIds)")
        print("[DEBUG] installedSkills count: \(installedSkills.count)")
        print("[DEBUG] installedSkills IDs: \(installedSkills.map { $0.id })")
        print("[DEBUG] enabledSkills count: \(enabledSkills.count)")
        print("[DEBUG] enabledSkills names: \(enabledSkills.map { $0.name })")

        switch agent.id {
        case "claude-code":
            // Claude Code: 管理 ~/.claude/skills/ 目录下的 skill 文件夹
            // 已验证: Claude Code 确实支持从 ~/.claude/skills/ 加载自定义 skills
            applySkillsToClaudeDirectory(agent: agent, skills: enabledSkills)
        case "cursor":
            // Cursor: 管理 ~/.cursor/skills/ 目录下的 skill 文件夹
            applySkillsToCursorDirectory(agent: agent, skills: enabledSkills)
        case "codex":
            // Codex: 管理 ~/.codex/skills/ 目录
            applySkillsToCodexDirectory(agent: agent, skills: enabledSkills)
        case "copilot-cli":
            writeCopilotConfig(skills: enabledSkills, configPath: getAgentConfigPath(agent))
        case "aider":
            writeAiderConfig(skills: enabledSkills, configPath: getAgentConfigPath(agent))
        case "gemini-cli":
            writeGeminiConfig(skills: enabledSkills, configPath: getAgentConfigPath(agent))
        case "glm-cli":
            writeGLMConfig(skills: enabledSkills, configPath: getAgentConfigPath(agent))
        case "kimi-cli":
            writeKimiConfig(skills: enabledSkills, configPath: getAgentConfigPath(agent))
        case "qwen-cli":
            writeQwenConfig(skills: enabledSkills, configPath: getAgentConfigPath(agent))
        case "vscode", "cursor-editor", "antigravity", "qoder", "codebuddy":
            writeEditorConfig(agent: agent, skills: enabledSkills, configPath: getAgentConfigPath(agent))
        case "roo-code", "roo":
            // Roo Code: 扫描 ~/.roo/rules/ 目录
            applySkillsToDirectory(agent: agent, skills: enabledSkills, directory: "~/.roo/rules")
        case "cline":
            // Cline: 扫描 ~/.cline/rules/ 目录
            applySkillsToDirectory(agent: agent, skills: enabledSkills, directory: "~/.cline/rules")
        case "windsurf":
            // Windsurf: 使用 ~/.codeium/windsurf/mcp_config.json 配置文件
            applySkillsToMCPConfig(agent: agent, skills: enabledSkills, configPath: "~/.codeium/windsurf/mcp_config.json")
        case "trae":
            // Trae: 使用 ~/.Trae/mcp.json 配置文件
            applySkillsToMCPConfig(agent: agent, skills: enabledSkills, configPath: "~/.Trae/mcp.json")
        default:
            // 默认使用目录方式
            let defaultDir = "~/.\(agent.id)/skills"
            applySkillsToDirectory(agent: agent, skills: enabledSkills, directory: defaultDir)
        }
    }

    // 获取 Agent 的配置文件路径
    private func getAgentConfigPath(_ agent: Agent) -> String {
        let homeDir = NSHomeDirectory()
        return agent.configPath.replacingOccurrences(of: "~", with: homeDir)
    }

    // MARK: - Claude Code: Skills 目录管理
    // Claude Code 从 ~/.claude/skills/ 加载自定义 skills
    // 每个 skill 是一个包含 SKILL.md 文件的目录
    // 已验证: Claude Code 确实支持自定义 skills
    private func applySkillsToClaudeDirectory(agent: Agent, skills: [InstalledSkill]) {
        let homeDir = NSHomeDirectory()
        let skillsDir = "\(homeDir)/.claude/skills"
        let fileManager = FileManager.default

        // 确保 skills 目录存在
        try? fileManager.createDirectory(atPath: skillsDir, withIntermediateDirectories: true)

        // 获取当前目录下所有的 skill 文件夹
        let existingSkills = (try? fileManager.contentsOfDirectory(atPath: skillsDir)) ?? []

        // 应该存在的 skills（启用的），使用 仓库名-技能名 作为唯一标识
        let enabledSkillLinkNames = Set(skills.map { skill -> String in
            let repoName = skill.localPath.components(separatedBy: "/").dropLast().last ?? "unknown"
            return "\(repoName)-\(skill.name)"
        })

        // 1. 添加新启用的 skills（创建符号链接）
        for skill in skills {
            // 从 localPath 提取仓库名，构造唯一的链接名
            let repoName = skill.localPath.components(separatedBy: "/").dropLast().last ?? "unknown"
            let skillLinkName = "\(repoName)-\(skill.name)"
            let skillLinkPath = "\(skillsDir)/\(skillLinkName)"
            let skillSourcePath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)

            // 如果已存在但不是链接，先删除
            if fileManager.fileExists(atPath: skillLinkPath) {
                try? fileManager.removeItem(atPath: skillLinkPath)
            }

            // 创建符号链接
            do {
                try fileManager.createSymbolicLink(atPath: skillLinkPath, withDestinationPath: skillSourcePath)
                print("Linked skill \(skillLinkName) to \(skillLinkPath)")
            } catch {
                print("Failed to link skill \(skillLinkName): \(error)")
            }
        }

        // 2. 移除禁用的 skills（删除链接）
        for existingSkill in existingSkills {
            if !enabledSkillLinkNames.contains(existingSkill) {
                let skillLinkPath = "\(skillsDir)/\(existingSkill)"
                try? fileManager.removeItem(atPath: skillLinkPath)
                print("Removed skill link: \(existingSkill)")
            }
        }

        print("Claude Code skills updated: \(skills.count) enabled")
    }

    // MARK: - 通用目录管理（适用于 Claude Code、Cursor、Codex、Roo Code 等）
    private func applySkillsToDirectory(agent: Agent, skills: [InstalledSkill], directory: String) {
        let homeDir = NSHomeDirectory()
        let skillsDir = directory.replacingOccurrences(of: "~", with: homeDir)
        let fileManager = FileManager.default

        print("Applying skills to directory: \(skillsDir)")

        // 确保 skills 目录存在
        do {
            try fileManager.createDirectory(atPath: skillsDir, withIntermediateDirectories: true)
        } catch {
            print("Failed to create directory: \(error)")
            return
        }

        // 获取当前目录下所有的 skill 文件夹
        let existingSkills = (try? fileManager.contentsOfDirectory(atPath: skillsDir)) ?? []

        // 应该存在的 skills（启用的），使用 仓库名-技能名 作为唯一标识
        let enabledSkillLinkNames = Set(skills.map { skill -> String in
            let repoName = skill.localPath.components(separatedBy: "/").dropLast().last ?? "unknown"
            return "\(repoName)-\(skill.name)"
        })

        // 1. 添加新启用的 skills（创建符号链接）
        for skill in skills {
            // 从 localPath 提取仓库名，构造唯一的链接名
            let repoName = skill.localPath.components(separatedBy: "/").dropLast().last ?? "unknown"
            let skillLinkName = "\(repoName)-\(skill.name)"
            let skillLinkPath = "\(skillsDir)/\(skillLinkName)"
            let skillSourcePath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)

            // 如果已存在，先删除
            if fileManager.fileExists(atPath: skillLinkPath) {
                try? fileManager.removeItem(atPath: skillLinkPath)
            }

            // 创建符号链接
            do {
                try fileManager.createSymbolicLink(atPath: skillLinkPath, withDestinationPath: skillSourcePath)
                print("Linked skill \(skillLinkName)")
            } catch {
                print("Failed to link skill \(skillLinkName): \(error)")
            }
        }

        // 2. 移除禁用的 skills（删除链接）
        for existingSkill in existingSkills {
            if !enabledSkillLinkNames.contains(existingSkill) {
                let skillLinkPath = "\(skillsDir)/\(existingSkill)"
                try? fileManager.removeItem(atPath: skillLinkPath)
                print("Removed skill link: \(existingSkill)")
            }
        }

        print("\(agent.name) skills updated: \(skills.count) enabled in \(skillsDir)")
    }

    // MARK: - MCP 配置管理（适用于 Copilot CLI、Windsurf、Trae 等）
    private func applySkillsToMCPConfig(agent: Agent, skills: [InstalledSkill], configPath: String) {
        let homeDir = NSHomeDirectory()
        let mcpConfigPath = configPath.replacingOccurrences(of: "~", with: homeDir)
        let fileManager = FileManager.default

        print("Applying skills to MCP config: \(mcpConfigPath)")

        // 读取现有配置
        var config: [String: Any] = [:]
        if let data = try? Data(contentsOf: URL(fileURLWithPath: mcpConfigPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        // 构建 MCP servers 配置
        var mcpServers: [String: Any] = [:]
        for skill in skills {
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)
            mcpServers[skill.name] = [
                "command": "node",
                "args": ["\(skillHomePath)/index.js"],
                "env": [:]
            ]
        }

        config["mcpServers"] = mcpServers

        // 确保目录存在
        let configDir = (mcpConfigPath as NSString).deletingLastPathComponent
        try? fileManager.createDirectory(atPath: configDir, withIntermediateDirectories: true)

        // 写入配置
        do {
            let data = try JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted, .sortedKeys])
            try data.write(to: URL(fileURLWithPath: mcpConfigPath))
            print("\(agent.name) MCP config updated with \(skills.count) servers")
        } catch {
            print("Failed to write MCP config: \(error)")
        }
    }

    // MARK: - Claude Code: MCP 配置管理
    private func writeClaudeMCPConfig(agent: Agent, skills: [InstalledSkill], configPath: String) {
        let homeDir = NSHomeDirectory()
        let mcpConfigPath = configPath.replacingOccurrences(of: "~", with: homeDir)
        let fileManager = FileManager.default

        print("[DEBUG] Applying \(skills.count) skills to Claude Code MCP config: \(mcpConfigPath)")

        // 读取现有配置
        var config: [String: Any] = [:]
        if let data = try? Data(contentsOf: URL(fileURLWithPath: mcpConfigPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        // 构建 MCP servers 配置
        var mcpServers: [String: Any] = config["mcpServers"] as? [String: Any] ?? [:]
        for skill in skills {
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)
            // 尝试找到 entry point（可能是 index.js、main.js 或 skill 目录本身）
            let possibleEntryPoints = ["index.js", "main.js", "skill.js", "run.js"]
            var entryPoint: String?
            for ep in possibleEntryPoints {
                if fileManager.fileExists(atPath: "\(skillHomePath)/\(ep)") {
                    entryPoint = ep
                    break
                }
            }

            if let entryPoint = entryPoint {
                mcpServers[skill.name] = [
                    "command": "node",
                    "args": ["\(skillHomePath)/\(entryPoint)"],
                    "env": [:]
                ]
            } else {
                // 如果没有找到 entry point，使用目录本身
                mcpServers[skill.name] = [
                    "command": "node",
                    "args": [skillHomePath],
                    "env": [:]
                ]
            }
        }

        config["mcpServers"] = mcpServers

        // 确保目录存在
        let configDir = (mcpConfigPath as NSString).deletingLastPathComponent
        try? fileManager.createDirectory(atPath: configDir, withIntermediateDirectories: true)

        // 写入配置
        do {
            let data = try JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted, .sortedKeys])
            try data.write(to: URL(fileURLWithPath: mcpConfigPath))
            print("Claude Code MCP config updated with \(skills.count) servers")
        } catch {
            print("Failed to write Claude Code MCP config: \(error)")
        }
    }

    // MARK: - Cursor: Skills 目录管理
    private func applySkillsToCursorDirectory(agent: Agent, skills: [InstalledSkill]) {
        let homeDir = NSHomeDirectory()
        let skillsDir = "\(homeDir)/.cursor/skills-cursor"
        let fileManager = FileManager.default

        print("[DEBUG] Applying \(skills.count) skills to Cursor directory: \(skillsDir)")
        for skill in skills {
            print("[DEBUG] - Skill: '\(skill.name)', source: '\(skill.localPath)'")
        }

        // 确保 skills 目录存在
        do {
            try fileManager.createDirectory(atPath: skillsDir, withIntermediateDirectories: true)
            print("[DEBUG] Created/verified directory: \(skillsDir)")
        } catch {
            print("[ERROR] Failed to create directory: \(error)")
            return
        }

        // 获取当前目录下所有的 skill 文件夹
        let existingSkills = (try? fileManager.contentsOfDirectory(atPath: skillsDir)) ?? []
        print("[DEBUG] Existing items in directory: \(existingSkills)")

        // 应该存在的 skills（启用的），使用 仓库名-技能名 作为唯一标识
        let enabledSkillLinkNames = Set(skills.map { skill -> String in
            let repoName = skill.localPath.components(separatedBy: "/").dropLast().last ?? "unknown"
            return "\(repoName)-\(skill.name)"
        })

        // 1. 添加新启用的 skills（创建符号链接）
        for skill in skills {
            // 从 localPath 提取仓库名，构造唯一的链接名
            let repoName = skill.localPath.components(separatedBy: "/").dropLast().last ?? "unknown"
            let skillLinkName = "\(repoName)-\(skill.name)"
            let skillLinkPath = "\(skillsDir)/\(skillLinkName)"
            let skillSourcePath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)

            print("[DEBUG] Processing skill '\(skill.name)' (repo: \(repoName)):")
            print("[DEBUG]   Link name: \(skillLinkName)")
            print("[DEBUG]   Link path: \(skillLinkPath)")
            print("[DEBUG]   Source path: \(skillSourcePath)")
            print("[DEBUG]   Source exists: \(fileManager.fileExists(atPath: skillSourcePath))")

            // 如果已存在，先删除
            if fileManager.fileExists(atPath: skillLinkPath) {
                print("[DEBUG]   Removing existing item at link path")
                do {
                    try fileManager.removeItem(atPath: skillLinkPath)
                } catch {
                    print("[ERROR]   Failed to remove existing item: \(error)")
                }
            }

            // 创建符号链接
            do {
                try fileManager.createSymbolicLink(atPath: skillLinkPath, withDestinationPath: skillSourcePath)
                print("[DEBUG]   ✓ Successfully linked '\(skillLinkName)'")
            } catch {
                print("[ERROR]   ✗ Failed to link '\(skillLinkName)': \(error)")
            }
        }

        // 2. 移除禁用的 skills（删除链接）
        for existingSkill in existingSkills {
            if !enabledSkillLinkNames.contains(existingSkill) {
                let skillLinkPath = "\(skillsDir)/\(existingSkill)"
                print("[DEBUG] Removing disabled skill: '\(existingSkill)'")
                do {
                    try fileManager.removeItem(atPath: skillLinkPath)
                    print("[DEBUG]   ✓ Removed '\(existingSkill)'")
                } catch {
                    print("[ERROR]   ✗ Failed to remove '\(existingSkill)': \(error)")
                }
            }
        }

        // 验证最终状态
        let finalItems = (try? fileManager.contentsOfDirectory(atPath: skillsDir)) ?? []
        print("[DEBUG] Final items in directory: \(finalItems)")
        print("[DEBUG] Cursor skills updated: \(skills.count) enabled, \(finalItems.count) items in directory")
    }

    // MARK: - Codex: Skills 目录管理
    private func applySkillsToCodexDirectory(agent: Agent, skills: [InstalledSkill]) {
        let homeDir = NSHomeDirectory()
        let skillsDir = "\(homeDir)/.codex/skills"
        let fileManager = FileManager.default

        // 确保 skills 目录存在
        try? fileManager.createDirectory(atPath: skillsDir, withIntermediateDirectories: true)

        // 获取当前目录下所有的 skill 文件夹
        let existingSkills = (try? fileManager.contentsOfDirectory(atPath: skillsDir)) ?? []

        // 应该存在的 skills（启用的），使用 仓库名-技能名 作为唯一标识
        let enabledSkillLinkNames = Set(skills.map { skill -> String in
            let repoName = skill.localPath.components(separatedBy: "/").dropLast().last ?? "unknown"
            return "\(repoName)-\(skill.name)"
        })

        // 1. 添加新启用的 skills（创建符号链接）
        for skill in skills {
            // 从 localPath 提取仓库名，构造唯一的链接名
            let repoName = skill.localPath.components(separatedBy: "/").dropLast().last ?? "unknown"
            let skillLinkName = "\(repoName)-\(skill.name)"
            let skillLinkPath = "\(skillsDir)/\(skillLinkName)"
            let skillSourcePath = skill.localPath.replacingOccurrences(of: "~", with: homeDir)

            // 如果已存在，先删除
            if fileManager.fileExists(atPath: skillLinkPath) {
                try? fileManager.removeItem(atPath: skillLinkPath)
            }

            // 创建符号链接
            do {
                try fileManager.createSymbolicLink(atPath: skillLinkPath, withDestinationPath: skillSourcePath)
                print("Linked skill \(skillLinkName) to \(skillLinkPath)")
            } catch {
                print("Failed to link skill \(skillLinkName): \(error)")
            }
        }

        // 2. 移除禁用的 skills（删除链接）
        for existingSkill in existingSkills {
            if !enabledSkillLinkNames.contains(existingSkill) {
                let skillLinkPath = "\(skillsDir)/\(existingSkill)"
                try? fileManager.removeItem(atPath: skillLinkPath)
                print("Removed skill link: \(existingSkill)")
            }
        }

        print("Codex skills updated: \(skills.count) enabled")
    }

    /// 根据 Agent 类型获取默认配置文件路径
    private func getDefaultConfigFilePath(inDirectory directory: String, for agent: Agent) -> String {
        let normalizedDir = directory.hasSuffix("/") ? directory : directory + "/"

        switch agent.id {
        case "claude-code":
            return normalizedDir + "config.json"
        case "codex":
            return normalizedDir + "config.toml"
        case "cursor":
            return normalizedDir + "mcp.json"
        case "copilot-cli":
            return normalizedDir + "config.json"
        case "aider":
            return normalizedDir + ".aider.conf.yml"
        case "gemini-cli", "glm-cli", "kimi-cli", "qwen-cli":
            return normalizedDir + "config.json"
        default:
            // 根据配置格式选择默认文件名
            switch agent.configFormat {
            case .json:
                return normalizedDir + "config.json"
            case .toml:
                return normalizedDir + "config.toml"
            case .yaml:
                return normalizedDir + "config.yaml"
            }
        }
    }

    func applyAllConfigs() {
        for agent in agents where agent.detected {
            applyConfigToAgent(agent)
        }
    }

    // MARK: - Config Writers for Each Agent

    private func writeClaudeConfig(skills: [InstalledSkill], configPath: String) {
        // Claude Code 使用 JSON 格式，支持 mcpServers 配置
        var config: [String: Any] = [:]

        // 读取现有配置（如果存在）
        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        // 构建 skills 配置
        let skillsConfig: [[String: Any]] = skills.map { skill in
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            return [
                "name": skill.name,
                "path": skillHomePath,
                "command": skill.command,
                "description": skill.description,
                "enabled": true
            ]
        }

        config["skills"] = skillsConfig

        // 写入文件
        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted, .sortedKeys]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
        }
    }

    private func writeCodexConfig(skills: [InstalledSkill], configPath: String) {
        // Codex 使用 TOML 格式
        var tomlContent = "# Codex Configuration\n"
        tomlContent += "# Auto-generated by Agent Skills Manager\n\n"

        if !skills.isEmpty {
            for skill in skills {
                let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
                tomlContent += "\n[[skills]]\n"
                tomlContent += "name = \"\(skill.name)\"\n"
                tomlContent += "path = \"\(skillHomePath)\"\n"
                tomlContent += "command = \"\(skill.command)\"\n"
                tomlContent += "description = \"\(skill.description.replacingOccurrences(of: "\"", with: "\\\""))\"\n"
                tomlContent += "enabled = true\n"
            }
        }

        try? tomlContent.write(toFile: configPath, atomically: true, encoding: .utf8)
    }

    private func writeCopilotConfig(skills: [InstalledSkill], configPath: String) {
        // GitHub Copilot CLI 使用 JSON 格式
        var config: [String: Any] = [:]

        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        let skillsConfig: [[String: Any]] = skills.map { skill in
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            return [
                "name": skill.name,
                "path": skillHomePath,
                "command": skill.command
            ]
        }

        config["skills"] = skillsConfig

        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
        }
    }

    private func writeAiderConfig(skills: [InstalledSkill], configPath: String) {
        // Aider 使用 YAML 格式
        var yamlContent = "# Aider Configuration\n"
        yamlContent += "# Auto-generated by Agent Skills Manager\n\n"

        if !skills.isEmpty {
            yamlContent += "skills:\n"
            for skill in skills {
                let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
                yamlContent += "  - name: \(skill.name)\n"
                yamlContent += "    path: \(skillHomePath)\n"
                yamlContent += "    command: \(skill.command)\n"
                yamlContent += "    description: \(skill.description)\n"
                yamlContent += "    enabled: true\n"
            }
        }

        try? yamlContent.write(toFile: configPath, atomically: true, encoding: .utf8)
    }

    private func writeCursorConfig(skills: [InstalledSkill], configPath: String) {
        print("Writing Cursor config to: \(configPath)")
        print("Skills count: \(skills.count)")

        // Cursor 使用 JSON 格式 (MCP 配置)
        var config: [String: Any] = [:]

        // 读取现有配置（如果存在）
        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
            print("Existing config loaded")
        } else {
            print("No existing config found, creating new")
        }

        // Cursor 使用 mcpServers 格式 - 完全替换为当前启用的 skills
        var mcpServers: [String: Any] = [:]

        for skill in skills {
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            print("Adding skill: \(skill.name) at path: \(skillHomePath)")
            mcpServers[skill.name] = [
                "command": "node",
                "args": ["\(skillHomePath)/index.js"],
                "env": [:]
            ]
        }

        config["mcpServers"] = mcpServers

        do {
            let data = try JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted, .sortedKeys])
            try data.write(to: URL(fileURLWithPath: configPath))
            print("Cursor config written successfully to \(configPath)")
        } catch {
            print("Failed to write Cursor config: \(error)")
        }
    }

    private func writeGeminiConfig(skills: [InstalledSkill], configPath: String) {
        var config: [String: Any] = [:]

        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        let skillsConfig: [[String: Any]] = skills.map { skill in
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            return [
                "name": skill.name,
                "path": skillHomePath,
                "command": skill.command,
                "enabled": true
            ]
        }

        config["skills"] = skillsConfig

        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
        }
    }

    private func writeGLMConfig(skills: [InstalledSkill], configPath: String) {
        var config: [String: Any] = [:]

        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        let skillsConfig: [[String: Any]] = skills.map { skill in
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            return [
                "name": skill.name,
                "path": skillHomePath,
                "command": skill.command,
                "enabled": true
            ]
        }

        config["skills"] = skillsConfig

        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
        }
    }

    private func writeKimiConfig(skills: [InstalledSkill], configPath: String) {
        var config: [String: Any] = [:]

        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        let skillsConfig: [[String: Any]] = skills.map { skill in
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            return [
                "name": skill.name,
                "path": skillHomePath,
                "command": skill.command,
                "enabled": true
            ]
        }

        config["skills"] = skillsConfig

        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
        }
    }

    private func writeQwenConfig(skills: [InstalledSkill], configPath: String) {
        var config: [String: Any] = [:]

        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        let skillsConfig: [[String: Any]] = skills.map { skill in
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            return [
                "name": skill.name,
                "path": skillHomePath,
                "command": skill.command,
                "enabled": true
            ]
        }

        config["skills"] = skillsConfig

        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
        }
    }

    private func writeEditorConfig(agent: Agent, skills: [InstalledSkill], configPath: String) {
        // 编辑器配置（VSCode:, Cursor, Trae 等）使用 JSON 格式
        var config: [String: Any] = [
            "version": "1.0",
            "agentId": agent.id,
            "agentName": agent.name
        ]

        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config.merge(existing) { (_, new) in new }
        }

        let skillsConfig: [[String: Any]] = skills.map { skill in
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            return [
                "id": skill.id,
                "name": skill.name,
                "description": skill.description,
                "path": skillHomePath,
                "command": skill.command,
                "author": skill.author,
                "version": skill.version,
                "enabled": true
            ]
        }

        config["skills"] = skillsConfig
        config["lastUpdated"] = ISO8601DateFormatter().string(from: Date())

        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted, .sortedKeys]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
        }
    }

    private func writeGenericJSONConfig(agent: Agent, skills: [InstalledSkill], configPath: String) {
        var config: [String: Any] = [:]

        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        let skillsConfig: [[String: Any]] = skills.map { skill in
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            return [
                "name": skill.name,
                "path": skillHomePath,
                "command": skill.command,
                "enabled": true
            ]
        }

        config["skills"] = skillsConfig

        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
        }
    }

    // MARK: - Open Config File
    func openAgentConfig(_ agent: Agent) {
        let homeDir = NSHomeDirectory()
        let configPath = agent.configPath.replacingOccurrences(of: "~", with: homeDir)

        // 如果文件不存在，先创建一个空的
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: configPath) {
            let configDir = (configPath as NSString).deletingLastPathComponent
            try? fileManager.createDirectory(atPath: configDir, withIntermediateDirectories: true)

            // 根据格式创建初始内容
            let initialContent: String
            switch agent.configFormat {
            case .json:
                initialContent = "{\n  \"skills\": []\n}"
            case .toml:
                initialContent = "# \(agent.name) Configuration\\n"
            case .yaml:
                initialContent = "# \(agent.name) Configuration\\n"
            }
            try? initialContent.write(toFile: configPath, atomically: true, encoding: .utf8)
        }

        // 打开文件
        let url = URL(fileURLWithPath: configPath)
        NSWorkspace.shared.open(url)
    }

    // MARK: - Update Agent Config Path
    func updateAgentConfigPath(_ agent: Agent, newPath: String) {
        guard let index = agents.firstIndex(where: { $0.id == agent.id }) else { return }
        agents[index].configPath = newPath
        saveData()

        // 自动将已启用的 skills 应用到新的配置文件
        applyConfigToAgent(agents[index])
    }

    // MARK: - Read/Edit Config Content
    func readAgentConfig(_ agent: Agent) -> String? {
        let homeDir = NSHomeDirectory()
        let configPath = agent.configPath.replacingOccurrences(of: "~", with: homeDir)

        guard FileManager.default.fileExists(atPath: configPath),
              let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
              let content = String(data: data, encoding: .utf8) else {
            return nil
        }
        return content
    }

    func saveAgentConfig(_ agent: Agent, content: String) -> Bool {
        let homeDir = NSHomeDirectory()
        let configPath = agent.configPath.replacingOccurrences(of: "~", with: homeDir)

        let fileManager = FileManager.default
        let configDir = (configPath as NSString).deletingLastPathComponent

        // 确保目录存在
        if !fileManager.fileExists(atPath: configDir) {
            try? fileManager.createDirectory(atPath: configDir, withIntermediateDirectories: true)
        }

        do {
            try content.write(toFile: configPath, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Failed to save config: \(error)")
            return false
        }
    }

    // MARK: - Persistence
    private func saveData() {
        let defaults = UserDefaults.standard
        if let reposData = try? JSONEncoder().encode(repositories) {
            defaults.set(reposData, forKey: "repositories")
        }
        if let skillsData = try? JSONEncoder().encode(installedSkills) {
            defaults.set(skillsData, forKey: "installedSkills")
        }
        if let agentsData = try? JSONEncoder().encode(agents) {
            defaults.set(agentsData, forKey: "agents")
        }
        // 保存主题设置
        defaults.set(colorScheme == .dark ? "dark" : "light", forKey: "colorScheme")
        // 保存语言设置
        defaults.set(language.rawValue, forKey: "language")
    }

    private func loadData() {
        let defaults = UserDefaults.standard

        if let reposData = defaults.data(forKey: "repositories"),
           let repos = try? JSONDecoder().decode([SkillRepository].self, from: reposData) {
            repositories = repos
        }

        if let skillsData = defaults.data(forKey: "installedSkills"),
           let skills = try? JSONDecoder().decode([InstalledSkill].self, from: skillsData) {
            installedSkills = skills
        }

        if let agentsData = defaults.data(forKey: "agents"),
           let loadedAgents = try? JSONDecoder().decode([Agent].self, from: agentsData) {
            agents = loadedAgents
        }

        // 加载主题设置
        if let theme = defaults.string(forKey: "colorScheme") {
            colorScheme = (theme == "dark") ? .dark : .light
        }
        // 加载语言设置
        if let lang = defaults.string(forKey: "language"),
           let savedLanguage = AppLanguage(rawValue: lang) {
            language = savedLanguage
            L.setLanguage(savedLanguage)
        }
    }

    // MARK: - Backup & Export
    func exportBackup() -> Result<Data, Error> {
        let backup = BackupData(
            repositories: repositories,
            installedSkills: installedSkills,
            agents: agents,
            exportDate: Date()
        )
        do {
            let data = try JSONEncoder().encode(backup)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }

    func importBackup(_ data: Data) -> Result<Void, Error> {
        do {
            let backup = try JSONDecoder().decode(BackupData.self, from: data)
            repositories = backup.repositories
            installedSkills = backup.installedSkills
            agents = backup.agents
            saveData()
            showToast("备份已恢复", type: .success)
            return .success(())
        } catch {
            showToast("恢复失败: \(error.localizedDescription)", type: .error)
            return .failure(error)
        }
    }

    struct BackupData: Codable {
        let repositories: [SkillRepository]
        let installedSkills: [InstalledSkill]
        let agents: [Agent]
        let exportDate: Date
    }
}

// MARK: - Color Extension
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
