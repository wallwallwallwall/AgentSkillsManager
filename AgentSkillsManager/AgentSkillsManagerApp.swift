import SwiftUI

@main
struct AgentSkillsManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 1100, height: 720)
        .windowResizability(.contentSize)
        .commands {
            // 文件菜单
            CommandGroup(after: .newItem) {
                Divider()
                Button("从 ZIP 导入...") {
                    NotificationCenter.default.post(name: .importFromZIP, object: nil)
                }
                .keyboardShortcut("o", modifiers: .command)

                Button("从目录导入...") {
                    NotificationCenter.default.post(name: .importFromDirectory, object: nil)
                }
                .keyboardShortcut("o", modifiers: [.command, .shift])
            }

            // 仓库菜单
            CommandMenu("仓库") {
                Button("添加仓库...") {
                    NotificationCenter.default.post(name: .showAddRepository, object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)

                Button("前往 Skill 仓库") {
                    NotificationCenter.default.post(name: .switchToRepositories, object: nil)
                }
                .keyboardShortcut("1", modifiers: .command)

                Button("前往 Skill 管理") {
                    NotificationCenter.default.post(name: .switchToMarketplace, object: nil)
                }
                .keyboardShortcut("2", modifiers: .command)

                Divider()

                Button("同步所有仓库") {
                    NotificationCenter.default.post(name: .syncAllRepositories, object: nil)
                }
                .keyboardShortcut("r", modifiers: .command)
            }

            // 工具菜单
            CommandMenu("工具") {
                Button("前往 Local Agents") {
                    NotificationCenter.default.post(name: .switchToAgents, object: nil)
                }
                .keyboardShortcut("3", modifiers: .command)

                Button("前往已安装") {
                    NotificationCenter.default.post(name: .switchToInstalled, object: nil)
                }
                .keyboardShortcut("4", modifiers: .command)

                Divider()

                Button("重新扫描本地模型") {
                    NotificationCenter.default.post(name: .rescanAgents, object: nil)
                }
                .keyboardShortcut("s", modifiers: .command)

                Button("应用配置到所有模型") {
                    NotificationCenter.default.post(name: .applyAllConfigs, object: nil)
                }
                .keyboardShortcut("a", modifiers: [.command, .shift])

                Divider()

                Button("搜索 Skills...") {
                    NotificationCenter.default.post(name: .focusSearch, object: nil)
                }
                .keyboardShortcut("f", modifiers: .command)
            }

        }
    }
}

// Notification Names
extension Notification.Name {
    static let showAddRepository = Notification.Name("showAddRepository")
    static let syncAllRepositories = Notification.Name("syncAllRepositories")
    static let rescanAgents = Notification.Name("rescanAgents")
    static let applyAllConfigs = Notification.Name("applyAllConfigs")
    static let importFromZIP = Notification.Name("importFromZIP")
    static let importFromDirectory = Notification.Name("importFromDirectory")
    static let switchToRepositories = Notification.Name("switchToRepositories")
    static let switchToMarketplace = Notification.Name("switchToMarketplace")
    static let switchToAgents = Notification.Name("switchToAgents")
    static let switchToInstalled = Notification.Name("switchToInstalled")
    static let focusSearch = Notification.Name("focusSearch")
}
