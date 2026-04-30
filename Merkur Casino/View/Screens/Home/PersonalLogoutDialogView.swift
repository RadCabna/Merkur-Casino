import SwiftUI

struct PersonalLogoutDialogView: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: screenHeight * 0.02) {
            HStack {
                Spacer()
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .font(.system(size: screenHeight * 0.024, weight: .regular))
                        .foregroundStyle(Color("appColor_2"))
                }
                .buttonStyle(.plain)
            }

            Circle()
                .fill(Color.red.opacity(0.1))
                .frame(width: screenHeight * 0.08, height: screenHeight * 0.08)
                .overlay(
                    Image(systemName: "arrow.right.square")
                        .font(.system(size: screenHeight * 0.038, weight: .regular))
                        .foregroundStyle(Color.red.opacity(0.75))
                )

            Text("Log Out?")
                .font(.custom("Montserrat-Bold", size: screenHeight * 0.03))
                .foregroundStyle(Color("appColor_2"))

            Text("Are you sure you want to end your session? You will need to log back in to access your casino bonuses.")
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.015))
                .foregroundStyle(Color("appColor_2").opacity(0.8))
                .multilineTextAlignment(.center)

            Button(action: onConfirm) {
                Text("Log Out")
                    .font(.custom("Montserrat-Bold", size: screenHeight * 0.02))
                    .foregroundStyle(.white)
                    .frame(maxWidth: screenHeight*0.3)
                    .frame(height: screenHeight * 0.05)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.9))
                    )
            }
            .buttonStyle(.plain)

            Button(action: onCancel) {
                Text("Cancel")
                    .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.02))
                    .foregroundStyle(Color("appColor_2").opacity(0.8))
            }
            .buttonStyle(.plain)
        }
        .padding(screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.03)
                .fill(.white)
                .shadow(color: .black.opacity(0.16), radius: 12, x: 0, y: 6)
        )
    }
}

#Preview {
    PersonalLogoutDialogView(onConfirm: {}, onCancel: {})
        .padding()
}
