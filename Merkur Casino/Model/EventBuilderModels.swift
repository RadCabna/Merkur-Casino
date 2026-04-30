import Foundation

enum EventType: String, CaseIterable, Identifiable {
    case tournament = "Tournament"
    case vipDinner = "VIP Dinner"
    case promoAction = "Promo Action"
    case privateGame = "Private Game"

    var id: String { rawValue }
}

enum DressCodeType: String, CaseIterable, Identifiable {
    case casual = "Casual"
    case smart = "Smart"
    case blackTie = "Black Tie"

    var id: String { rawValue }
}

enum VisibilityType: String, CaseIterable, Identifiable {
    case `public` = "Public"
    case vipOnly = "VIP Only"
    case invitationOnly = "Invitation Only"

    var id: String { rawValue }
}
