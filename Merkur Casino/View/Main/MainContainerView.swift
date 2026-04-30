import SwiftUI

struct MainContainerView: View {
    @StateObject private var viewModel = MainTabBarViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                selectedScreen
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .clipped()
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .animation(nil, value: viewModel.selectedMenu)
                BottomBarView(selectedMenu: $viewModel.selectedMenu)
                    .padding(.bottom, screenHeight * 0.05)
            }
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private var selectedScreen: some View {
        switch viewModel.selectedMenu {
        case .home:
            HomeMenuView()
        case .event:
            EventCalendarView()
        case .builder:
            EventBuilderView()
        case .list:
            EventListView()
        case .bonuses:
            BonusesMenuView()
        }
    }
}

#Preview {
    MainContainerView()
}
