import SwiftUI

struct BuilderChoiceChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.013))
                .foregroundStyle(Color("appColor_2"))
                .padding(.horizontal, screenHeight * 0.015)
                .frame(height: screenHeight * 0.045)
                .background(
                    Capsule()
                        .fill(isSelected ? Color("appColor_1") : Color(red: 0.9, green: 0.92, blue: 0.95))
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        BuilderChoiceChipView(title: "Tournament", isSelected: true) {}
        BuilderChoiceChipView(title: "VIP Dinner", isSelected: false) {}
    }
    .padding()
}
