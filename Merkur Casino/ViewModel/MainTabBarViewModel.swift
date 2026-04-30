import Foundation

final class MainTabBarViewModel: ObservableObject {
    @Published var selectedMenu: BottomMenuItem = .home
}
