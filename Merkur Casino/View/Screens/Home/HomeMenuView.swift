import SwiftUI
import ImageIO

struct HomeMenuView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var eventStore = EventStore.shared
    @AppStorage("logged_user_name") private var userName = "Slon"
    @AppStorage("profile_image_data") private var profileImageData: Data = Data()
    @State private var isRegistrationOverlayShown = false
    @State private var isPersonalShown = false
    @State private var profileCGImage: CGImage?

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: screenHeight * 0.02) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: screenHeight * 0.004) {
                        Text("WELCOME BACK,")
                            .font(.custom("Montserrat-Bold", size: screenHeight * 0.025))
                            .foregroundStyle(Color("appColor_2"))
                        Text(userName.uppercased())
                            .font(.custom("Montserrat-Bold", size: screenHeight * 0.03))
                            .foregroundStyle(Color("appColor_2"))
                    }
                    .padding(.horizontal, screenHeight * 0.02)
                    .padding(.vertical, screenHeight * 0.012)
                    .background(Color("appColor_1"))

                    Spacer()

                    Button {
                        isPersonalShown = true
                    } label: {
                        Circle()
                            .fill(Color("appColor_1"))
                            .frame(width: screenHeight * 0.062, height: screenHeight * 0.062)
                            .overlay(
                                Group {
                                    if let profileCGImage {
                                        Image(decorative: profileCGImage, scale: 1)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Image("photoPlaceholder")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: screenHeight * 0.032, height: screenHeight * 0.032)
                                    }
                                }
                                .clipShape(Circle())
                            )
                    }
                    .buttonStyle(.plain)
                }

                HomeLevelCardView(
                    levelTitle: viewModel.levelTitle,
                    currentXP: viewModel.currentXP,
                    nextLevelXP: viewModel.nextLevelXP
                )

                if let nearestEvent = viewModel.nearestEvent {
                    HomeNearestEventCardView(
                        event: nearestEvent,
                        isRegistered: eventStore.isRegistered(eventId: nearestEvent.eventId)
                    ) {
                        isRegistrationOverlayShown = true
                    }
                }

                Spacer()
            }
            .opacity(isRegistrationOverlayShown ? 0 : 1)
            .allowsHitTesting(!isRegistrationOverlayShown)
            .padding(.horizontal, screenHeight * 0.02)
            .padding(.top, screenHeight * 0.1)
            .padding(.bottom, screenHeight * 0.2)

            if isRegistrationOverlayShown, let nearestEvent = viewModel.nearestEvent {
                HomeRegistrationSuccessOverlayView(event: nearestEvent) {
                    eventStore.register(eventId: nearestEvent.eventId)
                    isRegistrationOverlayShown = false
                }
                .transition(.opacity)
            }
        }
        .background {
            Image("easyBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $isPersonalShown) {
            PersonalProfileView()
        }
        .onChange(of: profileImageData) { _, _ in
            loadProfileCGImage()
        }
        .onAppear {
            loadProfileCGImage()
        }
    }

    private func loadProfileCGImage() {
        guard !profileImageData.isEmpty else {
            profileCGImage = nil
            return
        }
        guard
            let source = CGImageSourceCreateWithData(profileImageData as CFData, nil),
            let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            profileCGImage = nil
            return
        }
        profileCGImage = image
    }
}

#Preview {
    HomeMenuView()
}
