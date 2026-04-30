import SwiftUI

struct HomeLevelCardView: View {
    let levelTitle: String
    let currentXP: Int
    let nextLevelXP: Int

    var progress: CGFloat {
        guard nextLevelXP > 0 else { return 0 }
        return min(max(CGFloat(currentXP) / CGFloat(nextLevelXP), 0), 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.012) {
            HStack {
                Text(levelTitle)
                    .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.02))
                    .foregroundStyle(Color("appColor_2"))
                Spacer()
                Circle()
                    .fill(Color("appColor_1"))
                    .frame(width: screenHeight * 0.032, height: screenHeight * 0.032)
                    .overlay(
                        Image("priseIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenHeight * 0.018, height: screenHeight * 0.018)
                    )
            }

            Text("Progression to King")
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.013))
                .foregroundStyle(Color("appColor_2").opacity(0.7))

            GeometryReader { proxy in
                let barWidth = proxy.size.width
                let horizontalPadding = screenHeight * 0.015
                let currentFontSize = screenHeight * 0.015
                let currentTextWidth = CGFloat("\(currentXP)".count) * currentFontSize * 0.6
                let fillWidth = barWidth * progress
                let hasReachedCurrentValueText = fillWidth >= (horizontalPadding + currentTextWidth + 2)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.95))
                        .frame(height: screenHeight * 0.024)

                    Capsule()
                        .fill(Color("appColor_2"))
                        .frame(width: barWidth * progress, height: screenHeight * 0.024)
                }
                .overlay {
                    HStack {
                        Text("\(currentXP)")
                            .font(.custom("Montserrat-SemiBold", size: currentFontSize))
                            .foregroundStyle(hasReachedCurrentValueText ? .white : Color("appColor_2"))
                            .shadow(color: .white.opacity(hasReachedCurrentValueText ? 0 : 0.9), radius: hasReachedCurrentValueText ? 0 : 1.2, x: 0, y: 0)
                        Spacer()
                        Text("\(nextLevelXP)")
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.015))
                            .foregroundStyle(Color("appColor_2").opacity(0.7))
                    }
                    .padding(.horizontal, horizontalPadding)
                }
            }
            .frame(height: screenHeight * 0.024)
        }
        .frame(maxWidth: .infinity)
        .padding(screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.025)
                .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    HomeLevelCardView(levelTitle: "Leader", currentXP: 7000, nextLevelXP: 19999)
        .padding()
}
