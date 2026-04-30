import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @AppStorage("logged_user_name") private var loggedUserName = "Slon"
    @State private var isPasswordTemporarilyVisible = false
    @State private var revealTask: Task<Void, Never>?
    let onSuccess: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: screenHeight * 0.028) {
                Text("LOGIN")
                    .font(.custom("Montserrat-Bold", size: screenHeight * 0.03))
                    .foregroundStyle(Color("appColor_2"))
                    .frame(width: screenHeight * 0.2, height: screenHeight * 0.045)
                    .background(Color("appColor_1"))
                    .padding(.top, screenHeight * 0.13)

                VStack(spacing: screenHeight * 0.018) {
                    loginField
                    passwordField

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.custom("Montserrat-Medium", size: screenHeight * 0.014))
                            .foregroundStyle(.red.opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    loginButton
                        .padding(.top, screenHeight * 0.02)
                }
                .padding(.horizontal, screenHeight * 0.03)
                .padding(.vertical, screenHeight * 0.03)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.03)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 7)
                )
                .padding(.horizontal, screenHeight * 0.02)

                Spacer()
            }
            .offset(y: screenHeight*0.04)
        }
        .background {
            Image("loginBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onDisappear {
            revealTask?.cancel()
        }
    }

    private var loginField: some View {
        HStack(spacing: screenHeight * 0.012) {
            Image(systemName: "person")
                .font(.system(size: screenHeight * 0.018, weight: .medium))
                .foregroundStyle(Color("appColor_2").opacity(0.55))

            TextField(
                text: $viewModel.login,
                placeholder: "Login...",
                textColor: Color("appColor_2"),
                placeholderColor: Color("appColor_2").opacity(0.45),
                fontSize: screenHeight * 0.02
            )
            .frame(height: screenHeight * 0.03)
        }
        .padding(.horizontal, screenHeight * 0.02)
        .frame(height: screenHeight * 0.058)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.03)
                .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
        )
    }

    private var passwordField: some View {
        HStack(spacing: screenHeight * 0.012) {
            Image(systemName: "lock")
                .font(.system(size: screenHeight * 0.018, weight: .medium))
                .foregroundStyle(Color("appColor_2").opacity(0.55))

            PasswordInputField(
                text: $viewModel.password,
                isSecure: !isPasswordTemporarilyVisible,
                placeholder: "Password...",
                textColor: Color("appColor_2"),
                placeholderColor: Color("appColor_2").opacity(0.45),
                fontSize: screenHeight * 0.02
            )
            .frame(height: screenHeight * 0.03)

            Button {
                revealTask?.cancel()
                isPasswordTemporarilyVisible = true
                revealTask = Task {
                    try? await Task.sleep(for: .seconds(1))
                    await MainActor.run {
                        isPasswordTemporarilyVisible = false
                    }
                }
            } label: {
                Image(systemName: isPasswordTemporarilyVisible ? "eye.slash" : "eye")
                    .font(.system(size: screenHeight * 0.02, weight: .medium))
                    .foregroundStyle(Color("appColor_2").opacity(0.6))
                    .frame(width: screenHeight * 0.04, height: screenHeight * 0.03)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, screenHeight * 0.02)
        .frame(height: screenHeight * 0.058)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.03)
                .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
        )
    }

    private var loginButton: some View {
        Button {
            if viewModel.authorize() {
                loggedUserName = viewModel.login
                onSuccess()
            }
        } label: {
            Text("Login")
                .font(.custom("Montserrat-Bold", size: screenHeight * 0.03))
                .foregroundStyle(Color("appColor_2").opacity(viewModel.isLoginEnabled ? 1 : 0.45))
                .frame(width: screenHeight * 0.2, height: screenHeight * 0.053)
                .background(
                    LinearGradient(
                        colors: [Color("gradientColor_1"), Color("gradientColor_2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(viewModel.isLoginEnabled ? 1 : 0.55)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LoginView {
    }
}

private struct TextField: View {
    @Binding var text: String
    let placeholder: String
    let textColor: Color
    let placeholderColor: Color
    let fontSize: CGFloat

    var body: some View {
        SwiftUI.TextField(
            "",
            text: $text,
            prompt: SwiftUI.Text(placeholder).foregroundColor(placeholderColor)
        )
        .font(.custom("Montserrat-Medium", size: fontSize))
        .foregroundStyle(textColor)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
    }
}
