import Foundation
import Combine

final class EventListViewModel: ObservableObject {
    @Published var selectedFilter: EventListFilter = .byDate
    @Published private(set) var events: [EventListItem] = []

    private let store: EventStore
    private var cancellables = Set<AnyCancellable>()

    init(store: EventStore = .shared) {
        self.store = store
        events = store.events
        store.$events
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.events = $0 }
            .store(in: &cancellables)
    }

    var filteredEvents: [EventListItem] {
        switch selectedFilter {
        case .byDate:
            return events.sorted { lhs, rhs in
                switch (lhs.parsedDate, rhs.parsedDate) {
                case let (leftDate?, rightDate?):
                    return leftDate < rightDate
                case (_?, nil):
                    return true
                case (nil, _?):
                    return false
                default:
                    return lhs.date < rhs.date
                }
            }
        case .byPrizePool:
            return events.sorted { lhs, rhs in
                lhs.prizePool > rhs.prizePool
            }
        }
    }

    func isRegistered(eventId: String) -> Bool {
        store.isRegistered(eventId: eventId)
    }

    func register(eventId: String) {
        store.register(eventId: eventId)
    }
}
