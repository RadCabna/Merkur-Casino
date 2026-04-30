import SwiftUI

struct EventCalendarView: View {
    @StateObject private var viewModel = EventCalendarViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            EventCalendarCardView(viewModel: viewModel)
                .padding(.horizontal, screenHeight * 0.02)
                .padding(.top, screenHeight * 0.09)
        }
        .background {
            Image("loginBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    EventCalendarView()
}
