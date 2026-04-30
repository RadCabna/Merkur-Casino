import SwiftUI
import CoreImage.CIFilterBuiltins
import UIKit

struct BonusScratchCardView: View {
    let state: BonusesViewModel.CardState
    let card: BonusCardItem
    let cardTimerText: String
    let onSwipe: () -> Void

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            frontFace
                .opacity(isFrontVisible ? 1 : 0)
            backFace
                .opacity(isFrontVisible ? 0 : 1)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(height: screenHeight * 0.23)
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.45), value: rotation)
        .onAppear {
            rotation = targetRotation(for: state)
        }
        .onChange(of: state) { _, newValue in
            rotation = targetRotation(for: newValue)
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 8)
                .onEnded { value in
                    let distance = hypot(value.translation.width, value.translation.height)
                    if state == .front && distance > 8 {
                        onSwipe()
                    }
                }
        )
    }

    private var isFrontVisible: Bool {
        state == .front
    }

    private func targetRotation(for state: BonusesViewModel.CardState) -> Double {
        state == .front ? 0 : 180
    }

    private var frontFace: some View {
        ZStack {
            RoundedRectangle(cornerRadius: screenHeight * 0.03)
                .fill(
                    RadialGradient(
                        colors: [Color(red: 0.16, green: 0.4, blue: 0.75), Color("appColor_2")],
                        center: .center,
                        startRadius: 0,
                        endRadius: screenHeight * 0.34
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: screenHeight * 0.03)
                        .stroke(Color("appColor_1"), lineWidth: 3)
                )
                .overlay(cornerMarks)

            VStack(spacing: screenHeight * 0.012) {
                Image(systemName: "sparkles")
                    .font(.system(size: screenHeight * 0.055, weight: .medium))
                    .foregroundStyle(Color("appColor_1"))
                Text("SWIPE TO SCRATCH")
                    .font(.custom("Montserrat-Bold", size: screenHeight * 0.03))
                    .foregroundStyle(Color("appColor_1"))
                Text("Reveal your daily casino reward")
                    .font(.custom("Montserrat-Medium", size: screenHeight * 0.014))
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
    }

    private var backFace: some View {
        ZStack {
            RoundedRectangle(cornerRadius: screenHeight * 0.03)
                .fill(
                    RadialGradient(
                        colors: [Color(red: 0.16, green: 0.4, blue: 0.75), Color("appColor_2")],
                        center: .center,
                        startRadius: 0,
                        endRadius: screenHeight * 0.34
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: screenHeight * 0.03)
                        .stroke(Color("appColor_1"), lineWidth: 3)
                )
                .overlay(cornerMarks)

            if state == .revealed {
                VStack(spacing: screenHeight * 0.012) {
                    BonusQRCodeView(qrData: card.qrCodeData)
                        .frame(width: screenHeight * 0.08, height: screenHeight * 0.08)
                    Text(card.description)
                        .font(.custom("Montserrat-Bold", size: screenHeight * 0.045))
                        .foregroundStyle(Color("appColor_1"))
                        .multilineTextAlignment(.center)
                    Text("Scan to claim this reward")
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.018))
                        .foregroundStyle(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, screenHeight * 0.02)
                }
            } else {
                VStack(spacing: screenHeight * 0.012) {
                    Text("Come back\ntomorrow")
                        .font(.custom("Montserrat-Bold", size: screenHeight * 0.03))
                        .foregroundStyle(Color("appColor_1"))
                        .multilineTextAlignment(.center)

                    HStack(spacing: screenHeight * 0.006) {
                        Image("scratchTimerIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenHeight * 0.018, height: screenHeight * 0.018)
                        Text(cardTimerText)
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.02))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.horizontal, screenHeight * 0.016)
                    .frame(height: screenHeight * 0.034)
                    .background(Capsule().fill(.white.opacity(0.18)))
                }
            }
        }
    }

    private var cornerMarks: some View {
        GeometryReader { proxy in
            let inset = screenHeight * 0.02
            ZStack(alignment: .topLeading) {
                cornerMark
                    .offset(x: inset, y: inset)
                cornerMark
                    .rotationEffect(.degrees(90))
                    .offset(x: proxy.size.width - inset - screenHeight * 0.028, y: inset)
                cornerMark
                    .rotationEffect(.degrees(-90))
                    .offset(x: inset, y: proxy.size.height - inset - screenHeight * 0.028)
                cornerMark
                    .rotationEffect(.degrees(180))
                    .offset(x: proxy.size.width - inset - screenHeight * 0.028, y: proxy.size.height - inset - screenHeight * 0.028)
            }
        }
    }

    private var cornerMark: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color("appColor_1").opacity(0.5))
                .frame(width: screenHeight * 0.028, height: 1)
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color("appColor_1").opacity(0.5))
                    .frame(width: 1, height: screenHeight * 0.028)
                Spacer(minLength: 0)
            }
            .frame(width: screenHeight * 0.028, height: screenHeight * 0.028)
        }
        .frame(width: screenHeight * 0.028, height: screenHeight * 0.028, alignment: .topLeading)
    }
}

private struct BonusQRCodeView: View {
    let qrData: String
    private let context = CIContext()
    private let qrFilter = CIFilter.qrCodeGenerator()
    private let colorFilter = CIFilter.falseColor()

    var body: some View {
        if let image = generateImage(from: qrData) {
            Image(decorative: image, scale: 1)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color("appColor_1"))
        } else {
            Image(systemName: "qrcode")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(Color("appColor_1"))
        }
    }

    private func generateImage(from string: String) -> CGImage? {
        let data = Data(string.utf8)
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.correctionLevel = "M"
        guard let outputImage = qrFilter.outputImage else { return nil }

        let qrColor = UIColor(named: "appColor_1") ?? .black
        colorFilter.inputImage = outputImage
        colorFilter.color0 = CIColor(color: qrColor)
        colorFilter.color1 = CIColor(red: 0, green: 0, blue: 0, alpha: 0)

        guard let coloredImage = colorFilter.outputImage else { return nil }
        let scaled = coloredImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        return context.createCGImage(scaled, from: scaled.extent)
    }
}

#Preview {
    BonusScratchCardView(
        state: .front,
        card: BonusCatalog.defaultCards[0],
        cardTimerText: "23h 14m remaining"
    ) {
    }
    .padding()
}
