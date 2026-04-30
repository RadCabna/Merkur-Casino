import SwiftUI

struct BottomBarView: View {
    @Binding var selectedMenu: BottomMenuItem
    @Namespace private var animationNamespace

    private var barWidth: CGFloat {
        UIScreen.main.bounds.width - screenHeight * 0.06
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(BottomMenuItem.allCases) { item in
                BottomBarItemView(
                    item: item,
                    isSelected: item == selectedMenu,
                    animationNamespace: animationNamespace
                ) {
                    selectedMenu = item
                }
            }
        }
        .padding(.horizontal, screenHeight * 0.04)
        .frame(height: screenHeight * 0.08)
        .frame(width: barWidth)
        .background(
            Capsule()
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 18, x: 0, y: 10)
        )
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        Image("bgWithElements")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        BottomBarView(selectedMenu: .constant(.event))
            .padding(.bottom, 40)
    }
}
