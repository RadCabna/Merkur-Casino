import Foundation

enum BonusPrizeType: String, Codable {
    case cashBonus = "cash_bonus"
    case freeSpins = "free_spins"
    case vipPoints = "vip_points"
    case tournamentTicket = "tournament_ticket"
}

struct BonusCardItem: Identifiable, Codable {
    let bonusId: String
    let prizeType: BonusPrizeType
    let prizeValue: Int?
    let currency: String?
    let game: String?
    let eventRef: String?
    let description: String
    let qrCodeData: String

    var id: String { bonusId }
}

enum BonusCatalog {
    static let defaultCards: [BonusCardItem] = [
        BonusCardItem(
            bonusId: "scratch_003",
            prizeType: .vipPoints,
            prizeValue: 2500,
            currency: nil,
            game: nil,
            eventRef: nil,
            description: "2,500 VIP Points",
            qrCodeData: "https://merkur.casino/scratch/scratch_003"
        ),
        BonusCardItem(
            bonusId: "scratch_001",
            prizeType: .cashBonus,
            prizeValue: 75,
            currency: "EUR",
            game: nil,
            eventRef: nil,
            description: "€75 Cash Bonus",
            qrCodeData: "https://merkur.casino/scratch/scratch_001"
        ),
        BonusCardItem(
            bonusId: "scratch_002",
            prizeType: .freeSpins,
            prizeValue: 40,
            currency: nil,
            game: "Book of Ra",
            eventRef: nil,
            description: "40 Free Spins on Book of Ra",
            qrCodeData: "https://merkur.casino/scratch/scratch_002"
        ),
        BonusCardItem(
            bonusId: "scratch_004",
            prizeType: .tournamentTicket,
            prizeValue: nil,
            currency: nil,
            game: nil,
            eventRef: "evt_2026_08_slots_tourney",
            description: "Ticket to Slots Mega Jackpot Battle",
            qrCodeData: "https://merkur.casino/scratch/scratch_004"
        )
    ]
}
