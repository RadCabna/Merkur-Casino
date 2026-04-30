import SwiftUI

struct PersonalStatsCardView: View {
    let iconName: String
    let value: String
    let title: String

    var body: some View {
        VStack(spacing: screenHeight * 0.00) {
           
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenHeight * 0.043, height: screenHeight * 0.043)
                

            Text(value)
                .font(.custom("Montserrat-Bold", size: screenHeight * 0.035))
                .foregroundStyle(Color("appColor_1"))

            Text(title)
                .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.014))
                .foregroundStyle(Color("appColor_2"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: screenHeight * 0.13)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02)
                .fill(.white)
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    PersonalStatsCardView(iconName: "priseIcon", value: "8", title: "TOURNAMENTS WON")
        .padding()
}
