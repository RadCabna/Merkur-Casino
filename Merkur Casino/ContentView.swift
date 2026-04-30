import SwiftUI

struct ContentView: View {
    @AppStorage("is_user_logged_in") private var isUserLoggedIn = false

    @ViewBuilder
    var body: some View {
        if isUserLoggedIn {
            MainContainerView()
        } else {
            LoginView(onSuccess: {
                isUserLoggedIn = true
            })
        }
    }
}

#Preview {
    ContentView()
}
