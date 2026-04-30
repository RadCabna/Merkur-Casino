import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    private struct LoyaltyLevel {
        let title: String
        let minPoints: Int
        let maxPoints: Int?
    }

    private let levels: [LoyaltyLevel] = [
        LoyaltyLevel(title: "Lone", minPoints: 0, maxPoints: 1_999),
        LoyaltyLevel(title: "Alpha", minPoints: 2_000, maxPoints: 6_999),
        LoyaltyLevel(title: "Leader", minPoints: 7_000, maxPoints: 19_999),
        LoyaltyLevel(title: "King", minPoints: 20_000, maxPoints: nil)
    ]

    @Published private(set) var currentXP: Int = 0
    @Published private(set) var nearestEvent: EventListItem?

    private let store: EventStore
    private let bonusStore: BonusStore
    private var cancellables = Set<AnyCancellable>()

    convenience init() {
        self.init(store: .shared, bonusStore: .shared)
    }

    convenience init(store: EventStore) {
        self.init(store: store, bonusStore: .shared)
    }

    init(store: EventStore, bonusStore: BonusStore) {
        self.store = store
        self.bonusStore = bonusStore
        nearestEvent = Self.calculateNearestEvent(from: store.events)
        currentXP = bonusStore.vipPoints

        store.$events
            .receive(on: RunLoop.main)
            .sink { [weak self] newEvents in
                self?.nearestEvent = Self.calculateNearestEvent(from: newEvents)
            }
            .store(in: &cancellables)

        bonusStore.$vipPoints
            .receive(on: RunLoop.main)
            .sink { [weak self] points in
                self?.currentXP = points
            }
            .store(in: &cancellables)
    }

    var levelTitle: String {
        currentLevel.title
    }

    var nextLevelXP: Int {
        currentLevel.maxPoints ?? currentXP
    }

    private var currentLevel: LoyaltyLevel {
        levels.first(where: { level in
            guard let maxPoints = level.maxPoints else {
                return currentXP >= level.minPoints
            }
            return currentXP >= level.minPoints && currentXP <= maxPoints
        }) ?? levels[0]
    }

    func isRegistered(eventId: String) -> Bool {
        store.isRegistered(eventId: eventId)
    }

    func register(eventId: String) {
        store.register(eventId: eventId)
    }

    private static func calculateNearestEvent(from events: [EventListItem]) -> EventListItem? {
        let today = Date()
        let upcoming = events
            .compactMap { item -> (EventListItem, Date)? in
                guard let date = item.parsedDate else { return nil }
                return (item, date)
            }
            .sorted { $0.1 < $1.1 }

        return upcoming.first(where: { $0.1 >= today })?.0 ?? upcoming.first?.0
    }
}
