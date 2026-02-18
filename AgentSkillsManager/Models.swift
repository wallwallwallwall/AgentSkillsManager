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
            skillPath: "/",
            localPath: "",
            lastSyncDate: nil,
            skills: []
        ),
        SkillRepository(
            id: UUID(),
            name: "openai-skills",
            url: "https://github.com/openai/skills",
            branch: "main",
            skillPath: "/",
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
            configPath: "~/.claude.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "codex",
            name: "OpenAI Codex",
            icon: "terminal.fill",
            colorHex: "10A37F",
            configPath: "~/.codex/config.toml",
            configFormat: .toml,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "copilot-cli",
            name: "GitHub Copilot CLI",
            icon: "cpu",
            colorHex: "06B6D4",
            configPath: "~/.copilot/config.json",
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
            configPath: "~/.cursor/mcp.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "gemini-cli",
            name: "Gemini CLI",
            icon: "sparkle",
            colorHex: "8B5CF6",
            configPath: "~/.gemini/config.json",
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
            configPath: "~/.kimi/config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "qwen-cli",
            name: "Qwen CLI (通义千问)",
            icon: "wand.and.stars",
            colorHex: "F59E0B",
            configPath: "~/.qwen/config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "vscode",
            name: "VSCode:",
            icon: "code",
            colorHex: "007ACC",
            configPath: "~/.vscode/skills/config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "cursor-editor",
            name: "Cursor Editor",
            icon: "cursorarrow",
            colorHex: "3B82F6",
            configPath: "~/.cursor/skills/config.json",
            configFormat: .json,
            detected: false,
            enabledSkillIds: []
        ),
        Agent(
            id: "trae",
            name: "Trae",
            icon: "bolt.fill",
            colorHex: "FF6B00",
            configPath: "~/.trae/skills/config.json",
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
            configPath: "~/.windsurf/skills/config.json",
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
        )
    ]
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
    @Published var language: Language = .chinese

    enum Language: String, CaseIterable {
        case chinese = "zh"
        case english = "en"

        var displayName: String {
            switch self {
            case .chinese: return "中文"
            case .english: return "English"
            }
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
        case repositories = "Skill仓库"
        case marketplace = "Skill管理"
        case agents = "Local Agents"
        case installed = "已安装"

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

        setupNotificationHandlers()
    }

    // MARK: - Cleanup Missing Skills
    /// 检查已安装 skill 的文件是否存在，如果不存在则从列表和 Agent 配置中清理
    func cleanupMissingSkills() {
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

        // 显示提示
        if !removedSkills.isEmpty {
            let skillNames = removedSkills.joined(separator: ", ")
            showToast("检测到 \(removedSkills.count) 个 Skill 文件缺失，已自动清理配置", type: .warning)
        }
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

    func addRepository(name: String, url: String, branch: String = "main", skillPath: String = "/") {
        let repo = SkillRepository(
            id: UUID(),
            name: name,
            url: url,
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
            repositories[index].url = url
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
                    self.showToast("成功同步 \(successCount) 个仓库", type: .success)
                } else {
                    self.showToast("同步完成: \(successCount) 成功, \(failCount) 失败", type: .warning)
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
        let isNewClone = !fileManager.fileExists(atPath: repoDir)

        // 如果目录存在但不是有效的 git 仓库，删除它
        if fileManager.fileExists(atPath: repoDir) && !isValidGitRepo {
            print("Directory exists but is not a valid git repo, removing: \(repoDir)")
            try? fileManager.removeItem(atPath: repoDir)
        }

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe

        return await withCheckedContinuation { continuation in
            Task {
                do {
                    var cloneSuccess = false
                    var finalErrorMessage = ""

                    if isNewClone || !isValidGitRepo {
                        // 新克隆 - 先尝试指定分支
                        task.arguments = ["-c", "GIT_HTTP_VERSION=1.1 git clone --depth 1 -b \(repository.branch) '\(repository.url)' '\(repoDir)' 2>&1"]
                        try task.run()
                        task.waitUntilExit()

                        if task.terminationStatus != 0 {
                            // 指定分支失败，清理目录并尝试不指定分支（自动检测默认分支）
                            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                            finalErrorMessage = String(data: errorData, encoding: .utf8) ?? "未知错误"

                            // 删除可能部分创建的目录
                            try? fileManager.removeItem(atPath: repoDir)

                            // 重新创建 Process 用于第二次尝试
                            let task2 = Process()
                            task2.launchPath = "/bin/bash"
                            let outputPipe2 = Pipe()
                            let errorPipe2 = Pipe()
                            task2.standardOutput = outputPipe2
                            task2.standardError = errorPipe2

                            // 不指定分支，让 git 自动检测默认分支
                            task2.arguments = ["-c", "GIT_HTTP_VERSION=1.1 git clone --depth 1 '\(repository.url)' '\(repoDir)' 2>&1 || (git config --global http.version HTTP/1.1 && git clone --depth 1 '\(repository.url)' '\(repoDir)')"]
                            try task2.run()
                            task2.waitUntilExit()

                            if task2.terminationStatus == 0 {
                                cloneSuccess = true
                            } else {
                                let errorData2 = errorPipe2.fileHandleForReading.readDataToEndOfFile()
                                let errorMessage2 = String(data: errorData2, encoding: .utf8) ?? "未知错误"
                                finalErrorMessage = "尝试指定分支 '\(repository.branch)' 失败: \(finalErrorMessage)\n\n尝试默认分支也失败: \(errorMessage2)"
                            }
                        } else {
                            cloneSuccess = true
                        }
                    } else {
                        // 已存在，执行 git pull
                        task.arguments = ["-c", "cd '\(repoDir)' && GIT_HTTP_VERSION=1.1 git pull origin \(repository.branch) 2>&1 || git pull origin \(repository.branch)"]
                        try task.run()
                        task.waitUntilExit()
                        cloneSuccess = task.terminationStatus == 0
                        if !cloneSuccess {
                            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                            finalErrorMessage = String(data: errorData, encoding: .utf8) ?? "拉取更新失败"
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

    nonisolated private static func parseSkillsFromDirectory(_ path: String, repositoryId: UUID) -> [RemoteSkill] {
        let fileManager = FileManager.default
        var skills: [RemoteSkill] = []

        guard let contents = try? fileManager.contentsOfDirectory(atPath: path) else {
            return skills
        }

        for item in contents {
            let itemPath = "\(path)/\(item)"
            var isDirectory: ObjCBool = false

            guard fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory),
                  isDirectory.boolValue else {
                continue
            }

            // 尝试解析 skill.json 或 package.json
            if let skill = parseSkillConfig(at: itemPath, name: item, repositoryId: repositoryId) {
                skills.append(skill)
            }
        }

        return skills
    }

    nonisolated private static func parseSkillConfig(at path: String, name: String, repositoryId: UUID) -> RemoteSkill? {
        let fileManager = FileManager.default

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

        // 如果没有配置文件，从 README 或目录名推断
        if config == nil {
            return Self.createSkillFromDirectory(path: path, name: name, repositoryId: repositoryId)
        }

        guard let config = config else { return nil }

        return RemoteSkill(
            id: config["id"] as? String ?? name,
            name: config["name"] as? String ?? name,
            description: config["description"] as? String ?? "No description",
            author: config["author"] as? String ?? "Unknown",
            version: config["version"] as? String ?? "1.0.0",
            license: config["license"] as? String ?? "Unknown",
            platforms: config["platforms"] as? [String] ?? ["Claude Code"],
            command: config["command"] as? String ?? "/\(name)",
            repositoryId: repositoryId,
            relativePath: name
        )
    }

    nonisolated private static func createSkillFromDirectory(path: String, name: String, repositoryId: UUID) -> RemoteSkill? {
        let fileManager = FileManager.default

        // 尝试读取 README.md
        let readmePath = "\(path)/README.md"
        var description = "Skill: \(name)"

        if fileManager.fileExists(atPath: readmePath),
           let content = try? String(contentsOfFile: readmePath, encoding: .utf8) {
            // 提取第一行作为描述
            let lines = content.components(separatedBy: .newlines)
            if let firstLine = lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) {
                description = firstLine.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: .whitespaces)
            }
        }

        return RemoteSkill(
            id: name,
            name: name,
            description: description,
            author: "Unknown",
            version: "1.0.0",
            license: "Unknown",
            platforms: ["Claude Code"],
            command: "/\(name)",
            repositoryId: repositoryId,
            relativePath: name
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

        // 目标路径：本地安装目录
        let installDir = "\(homeDir)/.agent-skills/installed/\(skill.name)"
        let localPath = "~/.agent-skills/installed/\(skill.name)"

        // 确保安装目录存在
        do {
            try fileManager.createDirectory(atPath: installDir, withIntermediateDirectories: true)
        } catch {
            showToast("创建安装目录失败: \(error.localizedDescription)", type: .error)
            return
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

        // 目标路径
        let installDir = "\(homeDir)/.agent-skills/installed/\(name)"
        let localPath = "~/.agent-skills/installed/\(name)"

        // 检查是否已存在
        if installedSkills.contains(where: { $0.name == name }) {
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
        }

        // 更新 installed skill 的分配记录
        if let skillIndex = installedSkills.firstIndex(where: { $0.id == skill.id }) {
            if installedSkills[skillIndex].assignedAgentIds.contains(agent.id) {
                installedSkills[skillIndex].assignedAgentIds.remove(agent.id)
            } else {
                installedSkills[skillIndex].assignedAgentIds.insert(agent.id)
            }
            saveData()
        }
    }

    func isSkillEnabledForAgent(_ skill: InstalledSkill, agent: Agent) -> Bool {
        agent.enabledSkillIds.contains(skill.id)
    }

    // 应用配置到 Agent 配置文件
    func applyConfigToAgent(_ agent: Agent) {
        let enabledSkills = installedSkills.filter { agent.enabledSkillIds.contains($0.id) }
        let homeDir = NSHomeDirectory()
        let configPath = agent.configPath.replacingOccurrences(of: "~", with: homeDir)

        // 确保配置文件的父目录存在
        let configDir = (configPath as NSString).deletingLastPathComponent
        let fileManager = FileManager.default
        try? fileManager.createDirectory(atPath: configDir, withIntermediateDirectories: true)

        switch agent.id {
        case "claude-code":
            writeClaudeConfig(skills: enabledSkills, configPath: configPath)
        case "codex":
            writeCodexConfig(skills: enabledSkills, configPath: configPath)
        case "copilot-cli":
            writeCopilotConfig(skills: enabledSkills, configPath: configPath)
        case "aider":
            writeAiderConfig(skills: enabledSkills, configPath: configPath)
        case "cursor":
            writeCursorConfig(skills: enabledSkills, configPath: configPath)
        case "gemini-cli":
            writeGeminiConfig(skills: enabledSkills, configPath: configPath)
        case "glm-cli":
            writeGLMConfig(skills: enabledSkills, configPath: configPath)
        case "kimi-cli":
            writeKimiConfig(skills: enabledSkills, configPath: configPath)
        case "qwen-cli":
            writeQwenConfig(skills: enabledSkills, configPath: configPath)
        case "vscode", "cursor-editor", "trae", "antigravity", "qoder", "windsurf", "codebuddy":
            writeEditorConfig(agent: agent, skills: enabledSkills, configPath: configPath)
        default:
            writeGenericJSONConfig(agent: agent, skills: enabledSkills, configPath: configPath)
        }

        print("Applied config to \(agent.name) at \(configPath)")
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
        // Cursor 使用 JSON 格式 (MCP 配置)
        var config: [String: Any] = [
            "mcpServers": [:]
        ]

        if let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let existing = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = existing
        }

        // Cursor 使用 mcpServers 格式
        var mcpServers: [String: Any] = (config["mcpServers"] as? [String: Any]) ?? [:]

        for skill in skills {
            let skillHomePath = skill.localPath.replacingOccurrences(of: "~", with: NSHomeDirectory())
            mcpServers[skill.name] = [
                "command": "node",
                "args": ["\(skillHomePath)/index.js"],
                "env": [:]
            ]
        }

        config["mcpServers"] = mcpServers

        if let data = try? JSONSerialization.data(withJSONObject: config, options: [.prettyPrinted, .sortedKeys]) {
            try? data.write(to: URL(fileURLWithPath: configPath))
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
           let savedLanguage = Language(rawValue: lang) {
            language = savedLanguage
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
