import Combine
import Foundation

final class BonusesViewModel: ObservableObject {
    enum CardState {
        case front
        case revealed
        case cooldown
    }

    @Published var cardState: CardState = .front
    @Published private(set) var usedCardsCount: Int = 0
    @Published private(set) var nextCardAvailableAt: Date?
    @Published private(set) var currentCard: BonusCardItem
    @Published private(set) var now = Date()

    private let store: BonusStore
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?

    init(store: BonusStore = .shared) {
        self.store = store
        currentCard = store.currentCard
        usedCardsCount = store.usedCardsCount
        nextCardAvailableAt = store.nextCardAvailableAt

        bindStore()
        updateCardState()
        startTimer()
    }

    var progressText: String {
        "\(usedCardsCount) / 3 used"
    }

    var progressValue: CGFloat {
        min(max(CGFloat(usedCardsCount) / 3, 0), 1)
    }

    var timerText: String {
        guard let nextCardAvailableAt else { return "New card available now" }
        let seconds = max(Int(nextCardAvailableAt.timeIntervalSince(now)), 0)
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "New card available in \(hours)h \(minutes)m"
    }

    var cardTimerText: String {
        guard let nextCardAvailableAt else { return "0h 0m remaining" }
        let seconds = max(Int(nextCardAvailableAt.timeIntervalSince(now)), 0)
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours)h \(minutes)m remaining"
    }

    var canSwipe: Bool {
        store.canUseCard(now: now) && cardState == .front
    }

    var canClaim: Bool {
        cardState == .revealed
    }

    func handleSwipeGesture() {
        guard canSwipe else { return }
        store.markCurrentCardRevealed()
        cardState = .revealed
    }

    func claimPrize() {
        guard canClaim else { return }
        cardState = .cooldown
        store.claimCurrentCard(now: Date())
    }

    private func bindStore() {
        store.$usedCardsCount
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.usedCardsCount = value
                self?.updateCardState()
            }
            .store(in: &cancellables)

        store.$nextCardAvailableAt
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.nextCardAvailableAt = value
                self?.updateCardState()
            }
            .store(in: &cancellables)

        store.$currentCardIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                currentCard = store.currentCard
                if cardState != .revealed {
                    updateCardState()
                }
            }
            .store(in: &cancellables)

        store.$isCurrentCardRevealed
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateCardState()
            }
            .store(in: &cancellables)
    }

    private func startTimer() {
        timerCancellable = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.now = date
                self?.updateCardState()
            }
    }

    private func updateCardState() {
        if store.canUseCard(now: now) {
            cardState = store.isCurrentCardRevealed ? .revealed : .front
        } else {
            cardState = .cooldown
        }
    }
}
