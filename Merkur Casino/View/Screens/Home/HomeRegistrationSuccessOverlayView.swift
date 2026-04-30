import SwiftUI
import ImageIO

struct HomeRegistrationSuccessOverlayView: View {
    let event: EventListItem
    let onClose: () -> Void

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: screenHeight * 0.018) {
                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: screenHeight * 0.026, weight: .regular))
                            .foregroundStyle(Color("appColor_2"))
                            .frame(width: screenHeight * 0.05, height: screenHeight * 0.05)
                            .offset(y: screenHeight*0.08)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, screenHeight * 0.03)

                Image("registrationSuccessIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenHeight * 0.08, height: screenHeight * 0.08)

                ticketCard

                Text("Registration Success!")
                    .font(.custom("Montserrat-Bold", size: screenHeight * 0.027))
                    .foregroundStyle(Color("appColor_1"))
            }
            .padding(.horizontal, screenHeight * 0.02)
            .padding(.bottom, screenHeight * 0.18)
        }
    }

    private var ticketCard: some View {
        VStack(spacing: 0) {
            Text(event.title.uppercased())
                .font(.custom("Montserrat-Bold", size: screenHeight * 0.02))
                .foregroundStyle(Color("appColor_2"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, screenHeight * 0.02)
                .padding(.vertical, screenHeight * 0.02)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.9, green: 0.92, blue: 0.95))
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                        .foregroundStyle(Color("appColor_2").opacity(0.45))
                        .frame(height: 1)
                }

            GeometryReader { proxy in
                ZStack {
                    Color.white
                    if event.bannerImagePath != nil {
                        registrationImage
                            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                            .clipped()
                    } else {
                        registrationImage
                            .frame(width: screenHeight * 0.18, height: screenHeight * 0.18)
                            .padding(screenHeight * 0.024)
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .clipShape(Rectangle())
            }
            .frame(height: screenHeight * 0.24)

            HStack {
                infoBlock(title: "DATE", value: event.date, icon: "calendrMark")
                Spacer()
                infoBlock(title: "TIME", value: event.time, icon: "calendarTimeIcon")
                Spacer()
                infoBlock(title: "BUY-IN", value: event.buyInLabel.replacingOccurrences(of: " Buy-in", with: ""), icon: "buyInIcon")
            }
            .padding(.horizontal, screenHeight * 0.02)
            .padding(.vertical, screenHeight * 0.016)
            .background(Color(red: 0.9, green: 0.92, blue: 0.95))

        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.03))
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.03)
                .stroke(Color("appColor_2"), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 10)
    }

    private func infoBlock(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.003) {
            HStack(spacing: screenHeight * 0.005) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenHeight * 0.015, height: screenHeight * 0.015)
                    .padding(.trailing, screenHeight * 0.002)
                Text(title)
                    .font(.custom("Montserrat-Medium", size: screenHeight * 0.012))
                    .foregroundStyle(Color("appColor_2").opacity(0.7))
            }
            Text(value)
                .font(.custom("Montserrat-Bold", size: screenHeight * 0.018))
                .foregroundStyle(Color("appColor_2"))
        }
    }

    @ViewBuilder
    private var registrationImage: some View {
        if let path = event.bannerImagePath {
            HomeRegistrationLocalFileImageView(fileURL: EventStore.shared.imageURL(for: path))
        } else {
            Image("successRegistrationPhotoPlaceholder")
                .resizable()
                .scaledToFill()
        }
    }
}

private struct HomeRegistrationLocalFileImageView: View {
    let fileURL: URL
    @State private var cgImage: CGImage?

    var body: some View {
        Group {
            if let cgImage {
                Image(decorative: cgImage, scale: 1)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("successRegistrationPhotoPlaceholder")
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
    HomeRegistrationSuccessOverlayView(event: EventCatalog.defaultEvents[0]) {
    }
}
