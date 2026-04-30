import SwiftUI

struct WeeklyProgressView: View {
    let usedCountText: String
    let progressValue: CGFloat
    let timerText: String

    var body: some View {
        GeometryReader { proxy in
            let iconSize = screenHeight * 0.055
            let contentWidth = max(0, proxy.size.width - iconSize - screenHeight * 0.014)

            HStack(alignment: .top, spacing: screenHeight * 0.014) {
                Circle()
                    .fill(Color("appColor_1"))
                    .frame(width: iconSize, height: iconSize)
                    .overlay(
                        Image(systemName: "info.circle")
                            .font(.system(size: screenHeight * 0.026, weight: .medium))
                            .foregroundStyle(.white)
                    )

                VStack(alignment: .leading, spacing: screenHeight * 0.008) {
                    HStack {
                        Text("Weekly Progress")
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.028))
                            .foregroundStyle(Color("appColor_2"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        Spacer(minLength: 8)
                        Text(usedCountText)
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.024))
                            .foregroundStyle(Color("appColor_2").opacity(0.7))
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                    }

                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color("appColor_2").opacity(0.6))
                            .frame(height: screenHeight * 0.012)
                        Capsule()
                            .fill(Color("appColor_1"))
                            .frame(width: max(0, contentWidth * progressValue), height: screenHeight * 0.012)
                    }
                    .frame(width: contentWidth)

                    Text(timerText)
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.018))
                        .foregroundStyle(Color("appColor_2").opacity(0.65))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: screenHeight * 0.095)
        .padding(screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.025)
                .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
        )
    }
}

#Preview {
    WeeklyProgressView(usedCountText: "1 / 3 used", progressValue: 0.33, timerText: "New card available in 14h 22m")
        .padding()
}
