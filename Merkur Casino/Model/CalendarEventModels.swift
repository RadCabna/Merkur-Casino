import Foundation

enum CalendarEventKind: String, Codable {
    case vip
    case tournament
    case regular
}

struct CalendarEventItem: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let date: Date
    let kind: CalendarEventKind
}
