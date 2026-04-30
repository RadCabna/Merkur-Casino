import SwiftUI

struct BuilderInputFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var errorText: String? = nil
    var isFocused: FocusState<Bool>.Binding? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.009) {
            Text(title)
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                .foregroundStyle(Color("appColor_2"))

            if let isFocused {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder)
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                        .foregroundColor(Color("appColor_2").opacity(0.75))
                )
                .focused(isFocused)
                .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                .foregroundStyle(Color("appColor_2"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, screenHeight * 0.02)
                .frame(height: screenHeight * 0.055)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.027)
                        .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                )
            } else {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder)
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                        .foregroundColor(Color("appColor_2").opacity(0.75))
                )
                .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                .foregroundStyle(Color("appColor_2"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, screenHeight * 0.02)
                .frame(height: screenHeight * 0.055)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.027)
                        .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                )
            }

            if let errorText {
                Text(errorText)
                    .font(.custom("Montserrat-Medium", size: screenHeight * 0.013))
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    BuilderInputFieldView(title: "Event title", placeholder: "High Roller Night", text: .constant(""), errorText: "Please fill this field", isFocused: nil)
        .padding()
}
