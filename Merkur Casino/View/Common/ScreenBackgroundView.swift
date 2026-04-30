import SwiftUI

struct ScreenBackgroundView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: screenHeight * 0.05, weight: .bold))
            .foregroundStyle(.white.opacity(0.95))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ZStack {
        Image("bgWithElements")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        ScreenBackgroundView(title: "Home")
    }
}
