import Foundation

enum BottomMenuItem: Int, CaseIterable, Identifiable {
    case home
    case event
    case builder
    case list
    case bonuses

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .event: "Event"
        case .builder: "Builder"
        case .list: "List"
        case .bonuses: "Bonuses"
        }
    }

    var activeIconName: String {
        "iconOn_\(rawValue + 1)"
    }

    var inactiveIconName: String {
        "iconOff_\(rawValue + 1)"
    }
}
