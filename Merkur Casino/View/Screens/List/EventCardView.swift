import SwiftUI
import ImageIO

struct EventCardView: View {
    let event: EventListItem
    let isRegistered: Bool
    let onRegisterTap: () -> Void
    @StateObject private var eventStore = EventStore.shared

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                headerImage
                    .frame(height: screenHeight * 0.18)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.02))

                HStack(spacing: screenHeight * 0.012) {
                    Text(event.dayLabel)
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.014))
                        .foregroundStyle(Color("appColor_2"))
                        .padding(.horizontal, screenHeight * 0.012)
                        .frame(height: screenHeight * 0.026)
                        .background(Capsule().fill(.white.opacity(0.95)))

                    Text(event.visibilityLabel)
                        .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.014))
                        .foregroundStyle(Color("appColor_2"))
                        .padding(.horizontal, screenHeight * 0.012)
                        .frame(height: screenHeight * 0.03)
                        .background(Capsule().fill(Color("appColor_1")))
                    Spacer()
                }
                .padding(screenHeight * 0.014)
            }

            VStack(alignment: .leading, spacing: screenHeight * 0.012) {
                Text(event.title)
                    .font(.custom("Montserrat-Bold", size: screenHeight * 0.024))
                    .foregroundStyle(Color("appColor_2"))
                    .lineLimit(1)

                HStack(spacing: screenHeight * 0.022) {
                    infoItem(iconName: "timeIcon", text: event.time)
                    infoItem(iconName: "cashIcon", text: event.buyInLabel)
                }

                HStack(spacing: screenHeight * 0.012) {
                    VStack(alignment: .leading, spacing: screenHeight * 0.004) {
                        Text("TOTAL PRIZE POOL")
                            .font(.custom("Montserrat-Medium", size: screenHeight * 0.013))
                            .foregroundStyle(Color("appColor_2").opacity(0.9))
                        HStack(spacing: screenHeight * 0.008) {
                            Image("priseIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenHeight * 0.022, height: screenHeight * 0.022)
                            Text(event.prizePoolLabel)
                                .font(.custom("Montserrat-Bold", size: screenHeight * 0.03))
                                .foregroundStyle(Color("appColor_2"))
                        }
                    }
                    Spacer()
                    Button(action: onRegisterTap) {
                        Text(isRegistered ? "Registered" : "Register")
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.02))
                            .foregroundStyle(Color("appColor_2"))
                            .frame(width: screenHeight * 0.14, height: screenHeight * 0.05)
                            .background(
                                Group {
                                    if isRegistered {
                                        Capsule().fill(Color(red: 0.88, green: 0.9, blue: 0.94))
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
                .padding(screenHeight * 0.014)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.017)
                        .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                )
            }
            .padding(.horizontal, screenHeight * 0.02)
            .padding(.vertical, screenHeight * 0.02)
            .background(.white)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.025))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    private func infoItem(iconName: String, text: String) -> some View {
        HStack(spacing: screenHeight * 0.007) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: screenHeight * 0.02, height: screenHeight * 0.02)
            Text(text)
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.015))
                .foregroundStyle(Color("appColor_2").opacity(0.85))
        }
    }

    @ViewBuilder
    private var headerImage: some View {
        if let path = event.bannerImagePath {
            EventCardLocalFileImageView(fileURL: eventStore.imageURL(for: path))
        } else {
            Image("eventCardPlaceholer")
                .resizable()
                .scaledToFill()
        }
    }
}

private struct EventCardLocalFileImageView: View {
    let fileURL: URL
    @State private var cgImage: CGImage?

    var body: some View {
        Group {
            if let cgImage {
                Image(decorative: cgImage, scale: 1)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("eventCardPlaceholer")
                    .resizable()
                    .scaledToFill()
            }
        }
        .task(id: fileURL) {
            guard let source = CGImageSourceCreateWithURL(fileURL as CFURL, nil),
                  let loadedImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
                cgImage = nil
                return
            }
            cgImage = loadedImage
        }
    }
}

#Preview {
    EventCardView(
        event: EventListItem(
            eventId: "evt_2026_08_merkur_poker",
            title: "Merkur Summer Poker Championship",
            date: "2026-08-15",
            time: "19:00",
            buyIn: 120,
            prizePool: 12000,
            currency: "EUR",
            status: "registration_open",
            bannerImage: "poker_championship_banner",
            bannerImagePath: nil,
            qrCodeData: "https://merkur.casino/events/evt_2026_08_merkur_poker",
            kind: .tournament
        ),
        isRegistered: false
    ) {
    }
    .padding()
}
