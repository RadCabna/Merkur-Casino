import Combine
import Foundation

final class BonusStore: ObservableObject {
    static let shared = BonusStore()

    @Published private(set) var usedCardsCount: Int
    @Published private(set) var nextCardAvailableAt: Date?
    @Published private(set) var currentCardIndex: Int
    @Published private(set) var claimedBonusIDs: Set<String>
    @Published private(set) var vipPoints: Int
    @Published private(set) var isCurrentCardRevealed: Bool

    let cards: [BonusCardItem]

    private let defaults = UserDefaults.standard
    private let usedCardsKey = "bonus_used_cards_count_v1"
    private let nextAvailableKey = "bonus_next_available_at_v1"
    private let currentCardIndexKey = "bonus_current_card_index_v1"
    private let claimedIDsKey = "bonus_claimed_ids_v1"
    private let vipPointsKey = "bonus_vip_points_v1"
    private let currentCardRevealedKey = "bonus_current_card_revealed_v1"

    private init() {
        cards = BonusCatalog.defaultCards
        usedCardsCount = defaults.integer(forKey: usedCardsKey)
        currentCardIndex = defaults.integer(forKey: currentCardIndexKey)
        vipPoints = defaults.integer(forKey: vipPointsKey)
        isCurrentCardRevealed = defaults.bool(forKey: currentCardRevealedKey)

        if let date = defaults.object(forKey: nextAvailableKey) as? Date {
            nextCardAvailableAt = date
        } else {
            nextCardAvailableAt = nil
        }

        if
            let data = defaults.data(forKey: claimedIDsKey),
            let decoded = try? JSONDecoder().decode([String].self, from: data) {
            claimedBonusIDs = Set(decoded)
        } else {
            claimedBonusIDs = []
        }

        if currentCardIndex < 0 || currentCardIndex >= cards.count {
            currentCardIndex = 0
        }
    }

    var currentCard: BonusCardItem {
        cards[currentCardIndex]
    }

    func canUseCard(now: Date = Date()) -> Bool {
        guard usedCardsCount < 3 else { return false }
        guard let nextCardAvailableAt else { return true }
        return now >= nextCardAvailableAt
    }

    func markCurrentCardRevealed() {
        isCurrentCardRevealed = true
        defaults.set(true, forKey: currentCardRevealedKey)
    }

    func claimCurrentCard(now: Date = Date()) {
        guard canUseCard(now: now) else { return }

        let card = currentCard
        claimedBonusIDs.insert(card.bonusId)
        isCurrentCardRevealed = false
        defaults.set(false, forKey: currentCardRevealedKey)

        if card.prizeType == .vipPoints {
            vipPoints += card.prizeValue ?? 0
            defaults.set(vipPoints, forKey: vipPointsKey)
        }

        usedCardsCount = min(usedCardsCount + 1, 3)
        defaults.set(usedCardsCount, forKey: usedCardsKey)

        nextCardAvailableAt = Calendar.current.date(byAdding: .day, value: 1, to: now)
        defaults.set(nextCardAvailableAt, forKey: nextAvailableKey)

        if !cards.isEmpty {
            currentCardIndex = min(currentCardIndex + 1, cards.count - 1)
            defaults.set(currentCardIndex, forKey: currentCardIndexKey)
        }

        persistClaimedIDs()
    }

    private func persistClaimedIDs() {
        if let data = try? JSONEncoder().encode(Array(claimedBonusIDs)) {
            defaults.set(data, forKey: claimedIDsKey)
        }
    }
}
