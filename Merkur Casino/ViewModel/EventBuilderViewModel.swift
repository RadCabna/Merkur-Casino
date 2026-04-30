import Foundation

final class EventBuilderViewModel: ObservableObject {
    enum ValidationField {
        case title
        case date
        case time
        case location
        case prizeFund
    }

    @Published var eventTitle = ""
    @Published var location = ""
    @Published var date: Date?
    @Published var startTime: Date?
    @Published var endTime: Date?
    @Published var selectedEventType: EventType = .tournament
    @Published var buyIn = ""
    @Published var prizeFund = ""
    @Published var maxParticipants = ""
    @Published var selectedDressCode: DressCodeType = .smart
    @Published var description = ""
    @Published var selectedVisibility: VisibilityType = .public

    func buildEvent(bannerImagePath: String?) -> EventListItem? {
        let trimmedTitle = eventTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return nil }
        let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedLocation.isEmpty else { return nil }
        guard let date else { return nil }
        guard let startTime else { return nil }
        let buyInValue = parseAmount(from: buyIn) ?? 0
        guard let prizeFundValue = parseAmount(from: prizeFund) else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "HH:mm"

        return EventListItem(
            eventId: "evt_custom_\(UUID().uuidString.lowercased())",
            title: trimmedTitle,
            date: dateFormatter.string(from: date),
            time: timeFormatter.string(from: startTime),
            buyIn: buyInValue,
            prizePool: prizeFundValue,
            currency: "EUR",
            status: selectedVisibility == .invitationOnly ? "waitlist" : "registration_open",
            bannerImage: "eventCardPlaceholer",
            bannerImagePath: bannerImagePath,
            qrCodeData: "",
            kind: mapEventKind(selectedEventType)
        )
    }

    func resetForm() {
        eventTitle = ""
        location = ""
        date = nil
        startTime = nil
        endTime = nil
        selectedEventType = .tournament
        buyIn = ""
        prizeFund = ""
        maxParticipants = ""
        selectedDressCode = .smart
        description = ""
        selectedVisibility = .public
    }

    var firstInvalidField: ValidationField? {
        if eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return .title }
        if date == nil { return .date }
        if startTime == nil { return .time }
        if location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return .location }
        if parseAmount(from: prizeFund) == nil { return .prizeFund }
        return nil
    }

    var isSaveValid: Bool {
        firstInvalidField == nil
    }

    private func parseAmount(from value: String) -> Int? {
        let digits = value.filter(\.isNumber)
        return Int(digits)
    }

    private func mapEventKind(_ type: EventType) -> CalendarEventKind {
        switch type {
        case .tournament:
            return .tournament
        case .vipDinner:
            return .vip
        case .promoAction, .privateGame:
            return .regular
        }
    }
}
