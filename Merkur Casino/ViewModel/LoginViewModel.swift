import Foundation

final class LoginViewModel: ObservableObject {
    @Published var login = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var errorMessage = ""

    private let validLogin = "Slon"
    private let validPassword = "12345"
    private let minimumPasswordLength = 5

    var isLoginEnabled: Bool {
        login.count > 0 && password.count >= minimumPasswordLength
    }

    func authorize() -> Bool {
        guard password.count >= minimumPasswordLength else {
            errorMessage = "Password must be at least 5 characters"
            return false
        }

        guard login == validLogin, password == validPassword else {
            errorMessage = "Invalid login or password"
            return false
        }

        errorMessage = ""
        return true
    }
}
