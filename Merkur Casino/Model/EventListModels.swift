import Foundation

struct EventListItem: Identifiable, Codable {
    let eventId: String
    let title: String
    let date: String
    let time: String
    let buyIn: Int
    let prizePool: Int
    let currency: String
    let status: String
    let bannerImage: String
    let bannerImagePath: String?
    let qrCodeData: String
    let kind: CalendarEventKind

    var id: String { eventId }

    var dayLabel: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d"
        guard let parsedDate else { return date }
        return formatter.string(from: parsedDate)
    }

    var parsedDate: Date? {
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd"
        return parser.date(from: date)
    }

    var visibilityLabel: String {
        switch status {
        case "registration_open":
            return "OPEN"
        case "waitlist":
            return "WAITLIST"
        default:
            return status.replacingOccurrences(of: "_", with: " ").uppercased()
        }
    }

    var buyInLabel: String {
        buyIn == 0 ? "Free" : "\(currencySymbol)\(formattedAmount(buyIn)) Buy-in"
    }

    var prizePoolLabel: String {
        "\(currencySymbol)\(formattedAmount(prizePool))"
    }

    private var currencySymbol: String {
        switch currency {
        case "EUR": return "€"
        case "USD": return "$"
        case "GBP": return "£"
        default: return "\(currency) "
        }
    }

    private func formattedAmount(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}

enum EventListFilter: String, CaseIterable, Identifiable {
    case byDate = "By Date"
    case byPrizePool = "By Prize Pool"

    var id: String { rawValue }
}

enum EventCatalog {
    static let defaultEvents: [EventListItem] = [
        EventListItem(
            eventId: "evt_2026_08_merkur_poker",
            title: "Merkur Summer Poker Championship",
            date: "2026-08-15",
            time: "19:00",
            buyIn: 120,
            prizePool: 12000,
            currency: "EUR",
            status: "registration_open",
            bannerImage: "poker_championship_banner",
            bannerImagePath: nil,
            qrCodeData: "https://merkur.casino/events/evt_2026_08_merkur_poker",
            kind: .tournament
        ),
        EventListItem(
            eventId: "evt_2026_08_slots_tourney",
            title: "Slots Mega Jackpot Battle",
            date: "2026-08-25",
            time: "20:00",
            buyIn: 25,
            prizePool: 6500,
            currency: "EUR",
            status: "registration_open",
            bannerImage: "slots_mega_battle_banner",
            bannerImagePath: nil,
            qrCodeData: "https://merkur.casino/events/evt_2026_08_slots_tourney",
            kind: .tournament
        ),
        EventListItem(
            eventId: "evt_2026_09_vip_blackjack",
            title: "Elite Blackjack Gala",
            date: "2026-09-11",
            time: "21:00",
            buyIn: 300,
            prizePool: 18000,
            currency: "EUR",
            status: "waitlist",
            bannerImage: "blackjack_gala_banner",
            bannerImagePath: nil,
            qrCodeData: "https://merkur.casino/events/evt_2026_09_vip_blackjack",
            kind: .vip
        ),
        EventListItem(
            eventId: "evt_2026_09_rookie_cup",
            title: "Beginner’s Roulette Challenge",
            date: "2026-09-25",
            time: "18:30",
            buyIn: 15,
            prizePool: 1200,
            currency: "EUR",
            status: "registration_open",
            bannerImage: "roulette_challenge_banner",
            bannerImagePath: nil,
            qrCodeData: "https://merkur.casino/events/evt_2026_09_rookie_cup",
            kind: .regular
        )
    ]
}
