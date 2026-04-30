import SwiftUI

struct HomeNearestEventCardView: View {
    let event: EventListItem
    let isRegistered: Bool
    let onRegisterTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.014) {
            Text(event.title)
                .font(.custom("Montserrat-Bold", size: screenHeight * 0.022))
                .foregroundStyle(Color("appColor_2").opacity(0.75))
                .lineLimit(1)

            HStack {
                HStack(spacing: screenHeight * 0.006) {
                    Image("calendrMark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenHeight * 0.02, height: screenHeight * 0.02)
                    Text(event.date)
                        .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                        .foregroundStyle(Color("appColor_2").opacity(0.75))
                }

                Spacer()

                HStack(spacing: screenHeight * 0.006) {
                    Image("calendarTimeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenHeight * 0.02, height: screenHeight * 0.02)
                    Text(event.time)
                        .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                        .foregroundStyle(Color("appColor_2").opacity(0.75))
                }
            }

            HStack(spacing: screenHeight * 0.014) {
                VStack(alignment: .leading, spacing: screenHeight * 0.003) {
                    Text("PRIZE POOL")
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.013))
                        .foregroundStyle(Color("appColor_2").opacity(0.75))
                    Text(event.prizePoolLabel)
                        .font(.custom("Montserrat-Bold", size: screenHeight * 0.015))
                        .foregroundStyle(Color("appColor_2"))
                }

                VStack(alignment: .leading, spacing: screenHeight * 0.003) {
                    Text("BUY-IN")
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.013))
                        .foregroundStyle(Color("appColor_2").opacity(0.75))
                    Text(event.buyInLabel.replacingOccurrences(of: " Buy-in", with: ""))
                        .font(.custom("Montserrat-Bold", size: screenHeight * 0.015))
                        .foregroundStyle(Color("appColor_2"))
                }

                Spacer()

                Button(action: onRegisterTap) {
                    Text(isRegistered ? "Registered" : "Registration")
                        .font(.custom("Montserrat-Bold", size: screenHeight * 0.02))
                        .foregroundStyle(Color("appColor_2"))
                        .frame(width: screenHeight * 0.2, height: screenHeight * 0.055)
                        .background(
                            Group {
                                if isRegistered {
                                    Capsule()
                                        .fill(Color(red: 0.88, green: 0.9, blue: 0.94))
                                } else {
                                    LinearGradient(
                                        colors: [Color("gradientColor_1"), Color("gradientColor_2")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(isRegistered)
            }
        }
        .padding(screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.025)
                .fill(.white)
                .shadow(color: .black.opacity(0.14), radius: 12, x: 0, y: 6)
        )
    }
}

#Preview {
    HomeNearestEventCardView(event: EventCatalog.defaultEvents[0], isRegistered: false) {
    }
        .padding()
}
