import SwiftUI

struct PasswordInputField: View {
    @Binding var text: String
    var isSecure: Bool
    var placeholder: String
    var textColor: Color
    var placeholderColor: Color
    var fontSize: CGFloat
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder).foregroundColor(placeholderColor)
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .focused($isFocused)
            .font(.custom("Montserrat-Medium", size: fontSize))
            .foregroundStyle(isSecure ? .clear : textColor)

            if !text.isEmpty {
                Text(isSecure ? String(repeating: "•", count: text.count) : text)
                    .font(.custom("Montserrat-Medium", size: fontSize))
                    .foregroundStyle(textColor)
                    .allowsHitTesting(false)
            }
        }
        .onChange(of: isSecure) { _, _ in
            isFocused = true
        }
    }
}
