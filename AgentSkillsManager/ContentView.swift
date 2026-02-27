import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: viewModel)
                .navigationSplitViewColumnWidth(min: 240, ideal: 260)
        } detail: {
            MainContentView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.performInitialScan()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            // 应用回到前台时检查已安装 skill 文件是否存在
            viewModel.cleanupMissingSkills()
        }
        .onChange(of: viewModel.selectedTab) { newTab in
            // 切换到"已安装"标签页时检查文件是否存在
            if newTab == .installed {
                viewModel.cleanupMissingSkills()
            }
        }
        .overlay(
            ToastOverlay(viewModel: viewModel)
        )
        .preferredColorScheme(viewModel.colorScheme)
    }
}

// MARK: - Toast Overlay
struct ToastOverlay: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack {
            if let message = viewModel.toastMessage {
                HStack(spacing: 8) {
                    Image(systemName: viewModel.toastType.icon)
                        .foregroundColor(viewModel.toastType.color)
                    Text(message)
                        .font(.subheadline)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.windowBackgroundColor))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                .padding(.top, 20)
                .transition(.move(edge: .top).combined(with: .opacity))
                .frame(maxWidth: 400)
            }
            Spacer()
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.toastMessage)
    }
}

// MARK: - Sidebar
struct SidebarView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 0) {
            // App Title
            HStack {
                Image(systemName: "puzzlepiece.fill")
                    .font(.title)
                    .foregroundColor(.orange)
                Text("AgentSkillsManager")
                    .font(.title3.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
            }
            .padding()

            Divider()

            // Tab Selection - 使用 VStack 替代 List 以提高性能
            VStack(spacing: 4) {
                ForEach(AppViewModel.Tab.allCases, id: \.self) { tab in
                    SidebarTabButton(
                        tab: tab,
                        isSelected: viewModel.selectedTab == tab,
                        action: {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                viewModel.selectedTab = tab
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            Spacer()

            Divider()

            // Theme Toggle
            HStack {
                Image(systemName: viewModel.colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                    .foregroundColor(.secondary)
                Text(viewModel.colorScheme == .dark ? L.darkMode : L.lightMode)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.colorScheme = viewModel.colorScheme == .light ? .dark : .light
                    }
                }) {
                    Image(systemName: viewModel.colorScheme == .dark ? "moon.circle.fill" : "sun.max.circle")
                        .font(.title3)
                        .foregroundColor(viewModel.colorScheme == .dark ? .indigo : .orange)
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Divider()

            // Language Toggle
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.secondary)
                Text(L.languageLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.language = viewModel.language == .chinese ? .english : .chinese
                    }
                }) {
                    Text(viewModel.language.displayName)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Divider()

            // Detected Agents Summary
            VStack(alignment: .leading, spacing: 8) {
                Text(String(format: L.detectedAgents, viewModel.detectedAgents.count))
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    ForEach(viewModel.detectedAgents.prefix(5)) { agent in
                        Image(systemName: agent.icon)
                            .foregroundColor(agent.color)
                    }
                    if viewModel.detectedAgents.count > 5 {
                        Text("+\(viewModel.detectedAgents.count - 5)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Sidebar Tab Button
struct SidebarTabButton: View {
    let tab: AppViewModel.Tab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .white : tab.color)
                    .frame(width: 28, height: 28)

                Text(tab.displayName)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .primary)

                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? tab.color : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Main Content
struct MainContentView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        // 使用 ZStack 缓存所有视图，避免切换时重新创建
        ZStack {
            RepositoriesView(viewModel: viewModel)
                .opacity(viewModel.selectedTab == .repositories ? 1 : 0)
                .allowsHitTesting(viewModel.selectedTab == .repositories)

            MarketplaceView(viewModel: viewModel)
                .opacity(viewModel.selectedTab == .marketplace ? 1 : 0)
                .allowsHitTesting(viewModel.selectedTab == .marketplace)

            AgentsView(viewModel: viewModel)
                .opacity(viewModel.selectedTab == .agents ? 1 : 0)
                .allowsHitTesting(viewModel.selectedTab == .agents)

            InstalledSkillsView(viewModel: viewModel)
                .opacity(viewModel.selectedTab == .installed ? 1 : 0)
                .allowsHitTesting(viewModel.selectedTab == .installed)
        }
        .animation(.easeInOut(duration: 0.15), value: viewModel.selectedTab)
    }
}

// MARK: - Marketplace View
struct MarketplaceView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedSkill: RemoteSkill?

    var body: some View {
        VStack(spacing: 0) {
            // Header with Search
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.marketplaceTitle)
                        .font(.title2.bold())
                    Text(L.marketplaceSubtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Repository Filter
                Menu {
                    Button(L.allRepositories) {
                        viewModel.selectedRepositoryId = nil
                    }
                    Divider()
                    ForEach(viewModel.repositories) { repo in
                        Button(repo.name) {
                            viewModel.selectedRepositoryId = repo.id
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "shippingbox")
                            .font(.caption)
                        Text(viewModel.selectedRepositoryId == nil ? L.allRepositories : (viewModel.repositories.first { $0.id == viewModel.selectedRepositoryId }?.name ?? L.allRepositories))
                            .font(.subheadline)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(8)
                }

                // Search
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField(L.search + " Skills...", text: $viewModel.searchText)
                        .textFieldStyle(.plain)
                        .frame(width: 180)
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.controlBackgroundColor))
                .cornerRadius(8)
            }
            .padding()

            Divider()

            // Skills Grid
            if viewModel.filteredRemoteSkills.isEmpty {
                VStack(spacing: 20) {
                    Spacer()

                    Image(systemName: "cart")
                        .font(.system(size: 56))
                        .foregroundColor(.orange.opacity(0.6))

                    Text(L.marketplaceEmptyTitle)
                        .font(.title2.bold())
                        .foregroundColor(.primary)

                    if viewModel.repositories.isEmpty {
                        Text(L.noRepositoriesMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)

                        Button(L.goAddRepository) {
                            viewModel.selectedTab = .repositories
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                    } else if viewModel.repositories.allSatisfy({ $0.lastSyncDate == nil }) {
                        Text(L.repositoriesNeedSync)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)

                        Button(L.syncAllNow) {
                            Task {
                                await viewModel.syncAllRepositories()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                    } else {
                        Text(L.noSkillsInRepository)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.filteredRemoteSkills, id: \.uniqueId) { skill in
                            RemoteSkillRow(
                                viewModel: viewModel,
                                skill: skill,
                                isSelected: selectedSkill?.uniqueId == skill.uniqueId
                            )
                            .onTapGesture {
                                selectedSkill = skill
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $selectedSkill) { skill in
            RemoteSkillDetailView(viewModel: viewModel, skill: skill)
        }
    }
}

// MARK: - Remote Skill Row (List View)
struct RemoteSkillRow: View {
    @ObservedObject var viewModel: AppViewModel
    let skill: RemoteSkill
    let isSelected: Bool

    var isInstalled: Bool {
        viewModel.isSkillInstalled(skill)
    }

    var repositoryName: String {
        viewModel.repositories.first { $0.id == skill.repositoryId }?.name ?? L.unknownRepository
    }

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: "puzzlepiece.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.orange)
            }

            // Info
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(skill.name)
                        .font(.system(size: 14, weight: .semibold))
                    Text(skill.version)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    // 来源仓库标签
                    Text(repositoryName)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }

                Text(skill.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Install Status
            if isInstalled {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 18))
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(isSelected ? Color.orange.opacity(0.08) : Color(.windowBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.orange : Color(.separatorColor).opacity(0.5), lineWidth: isSelected ? 1.5 : 0.5)
        )
    }
}

// MARK: - Remote Skill Card (Grid View)
struct RemoteSkillCard: View {
    @ObservedObject var viewModel: AppViewModel
    let skill: RemoteSkill
    let isSelected: Bool
    @State private var isHovered = false
    @State private var isInstalled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "puzzlepiece.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.orange)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(skill.name)
                        .font(.headline)
                    Text(skill.author)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Install Status
                if isInstalled {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }

            Text(skill.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)

            HStack {
                Label(skill.version, systemImage: "number")
                Label(skill.license, systemImage: "doc.text")
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.secondary)

            // Platforms
            FlowLayout(spacing: 4) {
                ForEach(skill.platforms.prefix(3), id: \.self) { platform in
                    Text(platform)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
                if skill.platforms.count > 3 {
                    Text("+\(skill.platforms.count - 3)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(isHovered ? Color(.controlBackgroundColor) : Color(.textBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.orange : (isHovered ? Color.gray.opacity(0.3) : Color.clear), lineWidth: isSelected ? 2 : 1)
        )
        .onHover { hovered in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovered = hovered
            }
        }
        .onAppear {
            isInstalled = viewModel.isSkillInstalled(skill)
        }
    }
}

// MARK: - Repositories View
struct RepositoriesView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingAddRepo = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.repositoryTitle)
                        .font(.title2.bold())
                    Text(String(format: L.repositorySubtitle, viewModel.repositories.count))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if !viewModel.repositories.isEmpty {
                    Button(action: {
                        Task {
                            await viewModel.syncAllRepositories()
                        }
                    }) {
                        Label(L.syncAll, systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                }

                Button(action: { showingAddRepo = true }) {
                    Label(L.add, systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()

            Divider()

            if viewModel.repositories.isEmpty {
                VStack(spacing: 20) {
                    Spacer()

                    Image(systemName: "shippingbox")
                        .font(.system(size: 56))
                        .foregroundColor(.blue.opacity(0.6))

                    Text(L.manageRepositories)
                        .font(.title2.bold())

                    Text(L.noRepositoriesDesc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    Button(L.addFirstRepository) {
                        showingAddRepo = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.repositories) { repo in
                        RepositoryRow(viewModel: viewModel, repository: repo)
                    }
                }
                .listStyle(.plain)
            }
        }
        .sheet(isPresented: $showingAddRepo) {
            AddRepositoryView(viewModel: viewModel, isPresented: $showingAddRepo)
        }
        .onAppear {
            // 监听添加仓库通知
            NotificationCenter.default.addObserver(
                forName: .showAddRepository,
                object: nil,
                queue: .main
            ) { _ in
                showingAddRepo = true
            }
        }
    }
}

struct RepositoryRow: View {
    @ObservedObject var viewModel: AppViewModel
    let repository: SkillRepository
    @State private var showingErrorDetail = false
    @State private var showingEditRepo = false

    var isSyncing: Bool {
        viewModel.syncingRepositoryIds.contains(repository.id)
    }

    var syncError: String? {
        viewModel.repositorySyncErrors[repository.id]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.blue)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text(repository.name)
                        .font(.headline)
                    Text(repository.url)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                // Sync Status
                if isSyncing {
                    ProgressView()
                        .controlSize(.small)
                } else if let error = syncError {
                    Button(action: { showingErrorDetail = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(L.syncFailed)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .buttonStyle(.borderless)
                    .sheet(isPresented: $showingErrorDetail) {
                        SyncErrorDetailView(repositoryName: repository.name, errorMessage: error)
                    }
                } else if repository.lastSyncDate != nil {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(L.synced)
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("\(repository.skills.count) skills")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text(L.notSynced)
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                // Sync Button
                Button(action: {
                    Task {
                        let result = await viewModel.syncRepository(repository)
                        switch result {
                        case .success(let message):
                            viewModel.showToast("\(repository.name) \(message)", type: .success)
                        case .failure(_):
                            viewModel.showToast(L.syncFailed, type: .error)
                        }
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.borderless)
                .disabled(isSyncing)

                // Edit Button
                Button(action: {
                    showingEditRepo = true
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.borderless)

                // Delete Button
                Button(action: {
                    viewModel.deleteRepository(repository)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.borderless)
            }

            HStack {
                Label(repository.branch, systemImage: "arrow.branch")
                Label(repository.skillPath, systemImage: "folder")
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showingEditRepo) {
            EditRepositoryView(viewModel: viewModel, repository: repository, isPresented: $showingEditRepo)
        }
    }
}

// MARK: - Sync Error Detail View
struct SyncErrorDetailView: View {
    let repositoryName: String
    let errorMessage: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundColor(.red)

                Text("\(L.syncFailed): \(repositoryName)")
                    .font(.headline)

                Spacer()

                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
                .buttonStyle(.borderless)
            }

            Divider()

            // Error Message
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(L.errorDetails)
                        .font(.subheadline.bold())

                    Spacer()

                    Button(L.copy) {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(errorMessage, forType: .string)
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }

                ScrollView {
                    Text(errorMessage.isEmpty ? L.unknownError : errorMessage)
                        .font(.system(.callout, design: .monospaced))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }
                .frame(minHeight: 120, maxHeight: 280)
                .padding(12)
                .background(Color(.textBackgroundColor))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.separatorColor), lineWidth: 1)
                )
            }

            // Common Causes
            VStack(alignment: .leading, spacing: 6) {
                Text(L.possibleCauses)
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text("• \(L.errorNetwork)")
                    Text("• \(L.errorNotFound)")
                    Text("• \(L.errorBranch)")
                    Text("• \(L.errorGit)")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            // Close Button
            Button(L.close) {
                dismiss()
            }
            .keyboardShortcut(.cancelAction)
        }
        .padding(24)
        .frame(minWidth: 520, maxWidth: 600, minHeight: 400, maxHeight: 500)
    }
}

// MARK: - Agents View
struct AgentsView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.agentsTitle)
                        .font(.title2.bold())
                    Text(L.agentsSubtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {
                    viewModel.scanLocalAgents()
                }) {
                    Label(L.rescan, systemImage: "arrow.clockwise")
                }
            }
            .padding()

            Divider()

            if viewModel.detectedAgents.isEmpty {
                VStack(spacing: 20) {
                    Spacer()

                    Image(systemName: "cpu")
                        .font(.system(size: 56))
                        .foregroundColor(.green.opacity(0.6))

                    Text(L.noAgents)
                        .font(.title2.bold())

                    Text(L.noAgentsDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(L.status + ":")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack(spacing: 12) {
                            ForEach(viewModel.agents.prefix(4)) { agent in
                                HStack(spacing: 4) {
                                    Image(systemName: agent.icon)
                                        .foregroundColor(agent.color)
                                    Text(agent.name)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding(.top, 8)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                List {
                    Section(L.detected) {
                        ForEach(viewModel.detectedAgents) { agent in
                            AgentRow(viewModel: viewModel, agent: agent)
                        }
                    }

                    Section(L.undetectedAgents) {
                        ForEach(viewModel.agents.filter { !$0.detected }) { agent in
                            AgentRow(viewModel: viewModel, agent: agent)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct AgentRow: View {
    @ObservedObject var viewModel: AppViewModel
    let agent: Agent
    @State private var isExpanded = false
    @State private var showingConfigEditor = false
    @State private var editingConfigPath = false
    @State private var configPathInput = ""

    var enabledCount: Int {
        viewModel.installedSkills.filter { skill in
            agent.enabledSkillIds.contains(skill.id)
        }.count
    }

    var enabledSkills: [InstalledSkill] {
        viewModel.installedSkills.filter { skill in
            agent.enabledSkillIds.contains(skill.id)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                // Status Indicator
                Circle()
                    .fill(agent.detected ? Color.green : Color.gray)
                    .frame(width: 8, height: 8)

                // Icon
                Image(systemName: agent.icon)
                    .font(.title3)
                    .foregroundColor(agent.color)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text(agent.name)
                        .font(.headline)

                    HStack(spacing: 8) {
                        Text(agent.detected ? L.installed : L.notInstalled)
                            .font(.caption)
                            .foregroundColor(agent.detected ? .green : .secondary)

                        if agent.detected && enabledCount > 0 {
                            Text("•")
                                .foregroundColor(.secondary)
                            Text(String(format: L.skillsCount, enabledCount) + " " + L.enabled.lowercased())
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }

                    // Config Path - clickable to edit
                    Button(action: {
                        configPathInput = agent.configPath
                        editingConfigPath = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.text")
                                .font(.caption2)
                            Text(agent.configPath)
                                .font(.caption2)
                        }
                        .foregroundColor(.secondary)
                    }
                    .buttonStyle(.borderless)
                    .popover(isPresented: $editingConfigPath) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(L.configPath)
                                .font(.subheadline.bold())

                            TextField("~/.config/agent.json", text: $configPathInput)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 300)

                            HStack {
                                Spacer()

                                Button(L.cancel) {
                                    editingConfigPath = false
                                }
                                .buttonStyle(.borderless)

                                Button(L.save) {
                                    viewModel.updateAgentConfigPath(agent, newPath: configPathInput)
                                    editingConfigPath = false
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(configPathInput.isEmpty || configPathInput == agent.configPath)
                            }
                        }
                        .padding()
                    }
                }

                Spacer()

                if agent.detected {
                    HStack(spacing: 8) {
                        if isExpanded {
                            Image(systemName: "chevron.up")
                                .foregroundColor(.secondary)
                                .font(.system(size: 10))
                        } else {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                                .font(.system(size: 10))
                        }

                        Button(L.configure) {
                            showingConfigEditor = true
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .padding(.vertical, 8)
            .opacity(agent.detected ? 1.0 : 0.6)
            .contentShape(Rectangle())
            .onTapGesture {
                if agent.detected {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }

            // Expanded Skills Section
            .sheet(isPresented: $showingConfigEditor) {
                EditAgentConfigView(viewModel: viewModel, agent: agent, isPresented: $showingConfigEditor)
            }

            if isExpanded && agent.detected {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()

                    if viewModel.installedSkills.isEmpty {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.secondary)
                            Text(L.noSkillsInstalled)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    } else {
                        Text(L.manageEnabledSkills)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        VStack(spacing: 8) {
                            ForEach(viewModel.installedSkills) { skill in
                                Toggle(isOn: Binding(
                                    get: { viewModel.isSkillEnabledForAgent(skill, agent: agent) },
                                    set: { newValue in
                                        viewModel.toggleSkillForAgent(skill, agent: agent)
                                    }
                                )) {
                                    HStack {
                                        Image(systemName: "puzzlepiece.fill")
                                            .foregroundColor(.orange)
                                            .font(.caption)
                                        Text(skill.name)
                                            .font(.subheadline)
                                        Spacer()
                                        if viewModel.isSkillEnabledForAgent(skill, agent: agent) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.caption)
                                        }
                                    }
                                }
                                .toggleStyle(.switch)
                            }
                        }
                    }
                }
                .padding(.bottom, 8)
                .padding(.leading, 52) // Align with the text above
            }
        }
    }
}

// MARK: - Installed Skills View
struct InstalledSkillsView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedSkill: InstalledSkill?
    @State private var showingZIPImporter = false
    @State private var showingLocalImporter = false

    var body: some View {
        VStack(spacing: 0) {
            // Header with actions
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.installedSkillsTitle)
                        .font(.title2.bold())
                    Text(L.installedSkillsSubtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 12) {
                    Button {
                        showingZIPImporter = true
                    } label: {
                        Label(L.importFromZIP, systemImage: "doc.zipper")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        showingLocalImporter = true
                    } label: {
                        Label(L.importLocal, systemImage: "arrow.down.doc")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        viewModel.selectedTab = .marketplace
                    } label: {
                        Label(L.discoverSkills, systemImage: "sparkles")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()

            Divider()

            if viewModel.installedSkills.isEmpty {
                VStack(spacing: 24) {
                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.1))
                            .frame(width: 100, height: 100)

                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .foregroundColor(.purple.opacity(0.6))
                    }

                    VStack(spacing: 8) {
                        Text(L.noInstalledSkills)
                            .font(.title3.bold())

                        Text(L.noInstalledSkillsDesc)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    HStack(spacing: 12) {
                        Button(L.importFromZIP) {
                            showingZIPImporter = true
                        }
                        .buttonStyle(.bordered)

                        Button(L.importLocal) {
                            showingLocalImporter = true
                        }
                        .buttonStyle(.bordered)

                        Button(L.discoverSkills) {
                            viewModel.selectedTab = .marketplace
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 8)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                // Stats Bar
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Text(L.installedCount)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.installedSkills.count)")
                            .font(.caption.bold())
                            .foregroundColor(.primary)
                    }

                    ForEach(viewModel.detectedAgents) { agent in
                        if viewModel.installedSkills.contains(where: { $0.assignedAgentIds.contains(agent.id) }) {
                            Divider()
                                .frame(height: 12)

                            HStack(spacing: 4) {
                                Image(systemName: agent.icon)
                                    .font(.caption2)
                                    .foregroundColor(agent.color)
                                Text(agent.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(viewModel.installedSkills.filter { $0.assignedAgentIds.contains(agent.id) }.count)")
                                    .font(.caption.bold())
                                    .foregroundColor(.primary)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.controlBackgroundColor))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top, 8)

                List {
                    ForEach(viewModel.installedSkills) { skill in
                        InstalledSkillRow(viewModel: viewModel, skill: skill)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedSkill = skill
                            }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.uninstallSkill(viewModel.installedSkills[index])
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .sheet(item: $selectedSkill) { skill in
            InstalledSkillDetailView(viewModel: viewModel, skill: skill)
        }
        .sheet(isPresented: $showingZIPImporter) {
            ZIPImportView(viewModel: viewModel, isPresented: $showingZIPImporter)
        }
        .sheet(isPresented: $showingLocalImporter) {
            LocalImportView(viewModel: viewModel, isPresented: $showingLocalImporter)
        }
    }
}

struct InstalledSkillRow: View {
    @ObservedObject var viewModel: AppViewModel
    let skill: InstalledSkill
    @State private var isHovered = false

    var assignedCount: Int {
        skill.assignedAgentIds.count
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "puzzlepiece.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.orange)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(skill.name)
                    .font(.headline)

                Text(skill.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Label(skill.version, systemImage: "number")
                    Text("·")
                    Text(skill.license)

                    if assignedCount > 0 {
                        Text("·")
                        Label(String(format: L.assignedToAgents, assignedCount), systemImage: "cpu")
                            .foregroundColor(.blue)
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 12, weight: .semibold))
        }
        .padding()
        .background(isHovered ? Color(.controlBackgroundColor) : Color.clear)
        .cornerRadius(8)
        .onHover { hovered in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovered = hovered
            }
        }
    }
}

// MARK: - Detail Views
struct RemoteSkillDetailView: View {
    @ObservedObject var viewModel: AppViewModel
    let skill: RemoteSkill
    @Environment(\.dismiss) private var dismiss

    var isInstalled: Bool {
        viewModel.isSkillInstalled(skill)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.15))
                                .frame(width: 60, height: 60)
                            Image(systemName: "puzzlepiece.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.orange)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(skill.name)
                                .font(.title2.bold())
                            Text(skill.description)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }

                    Divider()

                    // Info
                    InfoSection(title: L.author) {
                        Text(skill.author)
                    }

                    InfoSection(title: L.version) {
                        Text(skill.version)
                    }

                    InfoSection(title: L.license) {
                        Text(skill.license)
                    }

                    InfoSection(title: L.command) {
                        HStack {
                            Text(skill.command)
                                .font(.system(.body, design: .monospaced))
                            Spacer()
                            Button(action: {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(skill.command, forType: .string)
                            }) {
                                Image(systemName: "doc.on.doc")
                            }
                            .buttonStyle(.borderless)
                        }
                        .padding()
                        .background(Color(.textBackgroundColor))
                        .cornerRadius(8)
                    }

                    InfoSection(title: L.supportedPlatforms) {
                        FlowLayout(spacing: 8) {
                            ForEach(skill.platforms, id: \.self) { platform in
                                Text(platform)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                            }
                        }
                    }

                    // Agent Assignment Section (only show if installed)
                    if let installedSkill = viewModel.installedSkills.first(where: { $0.originalRemoteId == skill.id && $0.repositoryId == skill.repositoryId }) {
                        Divider()

                        VStack(alignment: .leading, spacing: 12) {
                            Text(L.enableThisSkill)
                                .font(.headline)

                            if viewModel.detectedAgents.isEmpty {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(.orange)
                                    Text(L.noAgentsDetected)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.textBackgroundColor))
                                .cornerRadius(8)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(viewModel.detectedAgents) { agent in
                                        Toggle(isOn: Binding(
                                            get: { viewModel.isSkillEnabledForAgent(installedSkill, agent: agent) },
                                            set: { _ in
                                                viewModel.toggleSkillForAgent(installedSkill, agent: agent)
                                            }
                                        )) {
                                            HStack {
                                                Image(systemName: agent.icon)
                                                    .foregroundColor(agent.color)
                                                Text(agent.name)
                                                Spacer()
                                                if viewModel.isSkillEnabledForAgent(installedSkill, agent: agent) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.green)
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                        .toggleStyle(.switch)
                                    }
                                }
                                .padding()
                                .background(Color(.textBackgroundColor))
                                .cornerRadius(8)
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(L.skillDetails)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L.close) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .destructiveAction) {
                    if isInstalled {
                        Button(L.uninstall) {
                            if let installedSkill = viewModel.installedSkills.first(where: { $0.originalRemoteId == skill.id && $0.repositoryId == skill.repositoryId }) {
                                viewModel.uninstallSkill(installedSkill)
                            }
                        }
                        .foregroundColor(.red)
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    if isInstalled {
                        Button(L.installed) {}
                        .disabled(true)
                    } else {
                        Button(L.install) {
                            viewModel.installSkill(skill)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .frame(minWidth: 500, minHeight: 500)
    }
}

struct InstalledSkillDetailView: View {
    @ObservedObject var viewModel: AppViewModel
    let skill: InstalledSkill
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.15))
                                .frame(width: 60, height: 60)
                            Image(systemName: "puzzlepiece.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.orange)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(skill.name)
                                .font(.title2.bold())
                            Text(skill.description)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }

                    Divider()

                    // Agent Assignment
                    VStack(alignment: .leading, spacing: 12) {
                        // 标题行
                        HStack {
                            Text(L.selectAgents)
                                .font(.headline)
                            Spacer()
                        }

                        if viewModel.detectedAgents.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text(L.noAgentsDetectedInstallFirst)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                        } else {
                            // Agent 列表 - 单列布局确保名称完整显示
                            VStack(spacing: 0) {
                                ForEach(Array(viewModel.detectedAgents.enumerated()), id: \.element.id) { index, agent in
                                    AgentListRow(
                                        agent: agent,
                                        isEnabled: viewModel.isSkillEnabledForAgent(skill, agent: agent),
                                        onToggle: {
                                            viewModel.toggleSkillForAgent(skill, agent: agent)
                                        }
                                    )
                                    if index < viewModel.detectedAgents.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                            .background(Color(.textBackgroundColor))
                            .cornerRadius(8)
                        }

                        // 快捷操作按钮
                        if !viewModel.detectedAgents.isEmpty {
                            HStack(spacing: 12) {
                                Button(L.allEnable) {
                                    viewModel.agents.filter { $0.detected }.forEach { agent in
                                        if !viewModel.isSkillEnabledForAgent(skill, agent: agent) {
                                            viewModel.toggleSkillForAgent(skill, agent: agent)
                                        }
                                    }
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)

                                Button(L.allDisable) {
                                    viewModel.agents.filter { $0.detected }.forEach { agent in
                                        if viewModel.isSkillEnabledForAgent(skill, agent: agent) {
                                            viewModel.toggleSkillForAgent(skill, agent: agent)
                                        }
                                    }
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)

                                Spacer()
                            }
                            .padding(.top, 4)
                        }
                    }

                    Divider()

                    // Info
                    InfoSection(title: L.installPath) {
                        Text(skill.localPath)
                            .font(.system(.body, design: .monospaced))
                    }

                    InfoSection(title: L.installDate) {
                        Text(skill.installDate, style: .date)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(L.manageSkill)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L.close) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .destructiveAction) {
                    Button(L.uninstall) {
                        viewModel.uninstallSkill(skill)
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .frame(minWidth: 700, minHeight: 400)
    }
}

// MARK: - Agent List Row
struct AgentListRow: View {
    let agent: Agent
    let isEnabled: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // 图标 - 使用 Agent 品牌色
            Image(systemName: agent.icon)
                .font(.system(size: 14))
                .foregroundColor(agent.color.opacity(isEnabled ? 1.0 : 0.5))
                .frame(width: 28, height: 28)

            // 名称 - 使用 Agent 品牌色
            Text(agent.name)
                .font(.system(size: 13))
                .foregroundColor(agent.color.opacity(isEnabled ? 1.0 : 0.6))
                .lineLimit(1)

            Spacer()

            // 开关（带颜色）
            Toggle("", isOn: Binding(
                get: { isEnabled },
                set: { _ in onToggle() }
            ))
            .toggleStyle(SwitchToggleStyle(tint: agent.color))
            .controlSize(.small)
            .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - ZIP Import View
struct ZIPImportView: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var isPresented: Bool
    @State private var selectedPath: String?
    @State private var isImporting = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Image(systemName: "doc.zipper")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                }

                VStack(spacing: 8) {
                    Text(L.importZIPTitle)
                        .font(.title3.bold())

                    Text(L.zipImportDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                if let path = selectedPath {
                    HStack {
                        Image(systemName: "doc")
                            .foregroundColor(.secondary)
                        Text((path as NSString).lastPathComponent)
                            .font(.caption)
                            .foregroundColor(.primary)
                        Spacer()
                        Button {
                            selectedPath = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding()
                    .background(Color(.textBackgroundColor))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                if let error = errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                if isImporting {
                    ProgressView(L.importing)
                        .progressViewStyle(.circular)
                } else {
                    Button {
                        selectZIPFile()
                    } label: {
                        Label(selectedPath == nil ? L.selectZIP : L.changeFile, systemImage: "folder")
                            .frame(maxWidth: 200)
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L.cancel) {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(L.importTitle) {
                        importZIP()
                    }
                    .disabled(selectedPath == nil || isImporting)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .frame(width: 400, height: 450)
    }

    private func selectZIPFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.zip]
        panel.message = L.selectSkillZIPFile

        if panel.runModal() == .OK {
            selectedPath = panel.url?.path
            errorMessage = nil
        }
    }

    private func importZIP() {
        guard let path = selectedPath else { return }
        isImporting = true
        errorMessage = nil

        Task {
            let result = await viewModel.importSkillFromZIPAsync(path)

            await MainActor.run {
                isImporting = false
                switch result {
                case .success:
                    isPresented = false
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - Local Import View
struct LocalImportView: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var isPresented: Bool
    @State private var selectedPath: String?
    @State private var skillName = ""
    @State private var isImporting = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Image(systemName: "folder.badge.plus")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                }

                VStack(spacing: 8) {
                    Text(L.importDirectoryTitle)
                        .font(.title3.bold())

                    Text(L.localImportDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                if let path = selectedPath {
                    HStack {
                        Image(systemName: "folder")
                            .foregroundColor(.secondary)
                        Text((path as NSString).lastPathComponent)
                            .font(.caption)
                            .foregroundColor(.primary)
                        Spacer()
                        Button {
                            selectedPath = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding()
                    .background(Color(.textBackgroundColor))
                    .cornerRadius(8)
                    .padding(.horizontal)

                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text(L.nameLabel)
                            .font(.system(size: 14))
                            .frame(width: 60, alignment: .trailing)
                        TextField("my-skill", text: $skillName)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                }

                if let error = errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }

                if isImporting {
                    ProgressView(L.importing)
                        .progressViewStyle(.circular)
                } else {
                    Button {
                        selectDirectory()
                    } label: {
                        Label(selectedPath == nil ? L.selectDirectory : L.changeDirectory, systemImage: "folder")
                            .frame(maxWidth: 200)
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L.cancel) {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(L.importTitle) {
                        importDirectory()
                    }
                    .disabled(selectedPath == nil || skillName.isEmpty || isImporting)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .frame(width: 400, height: 480)
    }

    private func selectDirectory() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.message = L.selectSkillDirectory

        if panel.runModal() == .OK {
            selectedPath = panel.url?.path
            // 自动填充名称
            if let path = selectedPath {
                skillName = (path as NSString).lastPathComponent
            }
            errorMessage = nil
        }
    }

    private func importDirectory() {
        guard let path = selectedPath else { return }
        isImporting = true
        errorMessage = nil

        Task {
            let result = await viewModel.importSkillFromDirectoryAsync(path, name: skillName)

            await MainActor.run {
                isImporting = false
                switch result {
                case .success:
                    isPresented = false
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - Add Repository View
struct AddRepositoryView: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var isPresented: Bool

    @State private var name = ""
    @State private var url = ""
    @State private var branch = "main"
    @State private var skillPath = "/"

    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text(L.addRepository)
                .font(.title2.bold())
                .padding(.top, 8)

            // 表单
            Form {
                Section(L.repositoryInfo) {
                    TextField(L.skillName, text: $name, prompt: Text("awesome-claude-skills"))
                    TextField("GitHub URL", text: $url, prompt: Text("https://github.com/username/repo"))
                    TextField(L.branch, text: $branch, prompt: Text("main"))
                    TextField(L.skillPath, text: $skillPath, prompt: Text("/ (root)"))
                }

                Section(L.examples) {
                    Text("• ComposioHQ/awesome-claude-skills")
                    Text("• anthropics/skills")
                    Text("• openai/skills")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            // 按钮
            HStack(spacing: 12) {
                Button(L.cancel) {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Button(L.add) {
                    viewModel.addRepository(name: name, url: url, branch: branch, skillPath: skillPath)
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty || url.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 8)
        }
        .padding()
        .frame(width: 400, height: 380)
    }
}

// MARK: - Edit Repository View
struct EditRepositoryView: View {
    @ObservedObject var viewModel: AppViewModel
    let repository: SkillRepository
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var url: String = ""
    @State private var branch: String = ""
    @State private var skillPath: String = ""

    init(viewModel: AppViewModel, repository: SkillRepository, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.repository = repository
        self._isPresented = isPresented
        self._name = State(initialValue: repository.name)
        self._url = State(initialValue: repository.url)
        self._branch = State(initialValue: repository.branch)
        self._skillPath = State(initialValue: repository.skillPath)
    }

    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text(L.editRepository)
                .font(.title2.bold())
                .padding(.top, 8)

            // 表单
            Form {
                Section(L.repositoryInfo) {
                    TextField(L.skillName, text: $name)
                    TextField("GitHub URL", text: $url)
                    TextField(L.branch, text: $branch)
                    TextField(L.skillPath, text: $skillPath)
                }
            }

            Spacer()

            // 按钮
            HStack(spacing: 12) {
                Button(L.cancel) {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Button(L.save) {
                    viewModel.updateRepository(repository, name: name, url: url, branch: branch, skillPath: skillPath)
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty || url.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 8)
        }
        .padding()
        .frame(width: 400, height: 320)
    }
}

// MARK: - Edit Agent Config View
struct EditAgentConfigView: View {
    @ObservedObject var viewModel: AppViewModel
    let agent: Agent
    @Binding var isPresented: Bool

    @State private var configPath: String = ""
    @State private var configContent: String = ""
    @State private var isSaving = false
    @State private var saveError: String?

    init(viewModel: AppViewModel, agent: Agent, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.agent = agent
        self._isPresented = isPresented
        self._configPath = State(initialValue: agent.configPath)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: agent.icon)
                    .font(.title2)
                    .foregroundColor(agent.color)

                Text("\(agent.name) \(L.configure)")
                    .font(.headline)

                Spacer()

                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
                .buttonStyle(.borderless)
            }

            Divider()

            // Config Path Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(L.configPath)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button(L.open) {
                        viewModel.openAgentConfig(agent)
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.small)
                }

                HStack(spacing: 8) {
                    TextField("~/.config/agent.json", text: $configPath)
                        .textFieldStyle(.roundedBorder)

                    Button(L.save) {
                        viewModel.updateAgentConfigPath(agent, newPath: configPath)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .disabled(configPath == agent.configPath)
                }
            }

            Divider()

            // Config Content Editor
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(L.configFormat + ": \(agent.configFormat.rawValue.uppercased())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    if isSaving {
                        ProgressView()
                            .controlSize(.small)
                    } else if let error = saveError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    Button(L.save) {
                        saveConfig()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .disabled(isSaving)
                }

                TextEditor(text: $configContent)
                    .font(.system(.body, design: .monospaced))
                    .background(Color(.textBackgroundColor))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.separatorColor), lineWidth: 1)
                    )
            }

            Spacer()
        }
        .padding()
        .frame(minWidth: 600, minHeight: 500)
        .onAppear {
            loadConfig()
        }
    }

    private func loadConfig() {
        if let content = viewModel.readAgentConfig(agent) {
            configContent = content
        } else {
            // 创建默认内容
            switch agent.configFormat {
            case .json:
                configContent = "{\n  \"skills\": []\n}"
            case .toml:
                configContent = "# \(agent.name) Configuration\n"
            case .yaml:
                configContent = "# \(agent.name) Configuration\n"
            }
        }
    }

    private func saveConfig() {
        isSaving = true
        saveError = nil

        Task {
            let success = await MainActor.run {
                viewModel.saveAgentConfig(agent, content: configContent)
            }

            await MainActor.run {
                isSaving = false
                if success {
                    saveError = nil
                } else {
                    saveError = L.error
                }
            }
        }
    }
}

// MARK: - Helper Views
struct InfoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            content()
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text(title)
                .font(.title3)
                .foregroundColor(.secondary)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - FlowLayout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                self.size.width = max(self.size.width, x)
            }
            self.size.height = y + rowHeight
        }
    }
}

