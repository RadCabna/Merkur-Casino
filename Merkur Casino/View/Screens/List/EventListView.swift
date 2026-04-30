import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()
    @State private var selectedRegistrationEvent: EventListItem?

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: screenHeight * 0.02) {
                    HStack {
                        Spacer()
                        EventListFilterButtonView(selectedFilter: $viewModel.selectedFilter)
                    }
                    .padding(.top, screenHeight * 0.08)

                    LazyVStack(spacing: screenHeight * 0.02) {
                        ForEach(viewModel.filteredEvents) { event in
                            EventCardView(
                                event: event,
                                isRegistered: viewModel.isRegistered(eventId: event.eventId)
                            ) {
                                selectedRegistrationEvent = event
                            }
                        }
                    }
                }
                .opacity(selectedRegistrationEvent == nil ? 1 : 0)
                .allowsHitTesting(selectedRegistrationEvent == nil)
                .padding(.horizontal, screenHeight * 0.02)
                .padding(.bottom, screenHeight * 0.2)
            }

            if let event = selectedRegistrationEvent {
                HomeRegistrationSuccessOverlayView(event: event) {
                    viewModel.register(eventId: event.eventId)
                    selectedRegistrationEvent = nil
                }
            }
        }
        .background {
            Image("easyBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    EventListView()
}
