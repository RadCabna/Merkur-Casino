import SwiftUI

struct BonusesMenuView: View {
    @StateObject private var viewModel = BonusesViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: screenHeight * 0.025) {
                WeeklyProgressView(
                    usedCountText: viewModel.progressText,
                    progressValue: viewModel.progressValue,
                    timerText: viewModel.timerText
                )

                BonusScratchCardView(
                    state: viewModel.cardState,
                    card: viewModel.currentCard,
                    cardTimerText: viewModel.cardTimerText
                ) {
                    viewModel.handleSwipeGesture()
                }

                if viewModel.canClaim {
                    Button {
                        viewModel.claimPrize()
                    } label: {
                        Text("Claim Prize")
                            .font(.custom("Montserrat-Bold", size: screenHeight * 0.026))
                            .foregroundStyle(Color("appColor_2"))
                            .frame(width: screenHeight * 0.24, height: screenHeight * 0.055)
                            .background(
                                LinearGradient(
                                    colors: [Color("gradientColor_1"), Color("gradientColor_2")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }

                Spacer()
            }
            .padding(.horizontal, screenHeight * 0.02)
            .padding(.top, screenHeight * 0.08)
            .padding(.bottom, screenHeight * 0.2)
        }
        .background {
            Image("bgWithElements")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    BonusesMenuView()
}
