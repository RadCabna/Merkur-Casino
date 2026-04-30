import SwiftUI

struct BuilderSectionTitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.35), radius: 6, x: 0, y: 2)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    ZStack {
        Color.blue
        BuilderSectionTitleView(title: "Basic information")
    }
}
