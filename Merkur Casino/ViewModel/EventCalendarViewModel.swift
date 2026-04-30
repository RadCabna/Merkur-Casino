import Foundation
import Combine

final class EventCalendarViewModel: ObservableObject {
    @Published var displayedMonth: Date
    @Published var selectedDate: Date?
    @Published private(set) var events: [CalendarEventItem] = []

    private let store: EventStore
    private var cancellables = Set<AnyCancellable>()
    private let calendar = Calendar(identifier: .gregorian)

    init(store: EventStore = .shared) {
        self.store = store
        let today = Date()
        displayedMonth = today
        selectedDate = today
        events = Self.mapToCalendarEvents(store.events)

        store.$events
            .receive(on: RunLoop.main)
            .sink { [weak self] newEvents in
                self?.events = Self.mapToCalendarEvents(newEvents)
            }
            .store(in: &cancellables)
    }

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth).uppercased()
    }

    var daysInGrid: [Date?] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
            let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday,
            let dayRange = calendar.range(of: .day, in: .month, for: displayedMonth)
        else {
            return []
        }

        let leading = firstWeekday - 1
        var result: [Date?] = Array(repeating: nil, count: leading)
        for day in dayRange {
            result.append(calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start))
        }
        return result
    }

    var selectedEvents: [CalendarEventItem] {
        guard let selectedDate else { return [] }
        return eventsForDate(selectedDate)
    }

    func select(date: Date?) {
        selectedDate = date
    }

    func eventsForDate(_ date: Date) -> [CalendarEventItem] {
        events.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func goToPreviousMonth() {
        guard let previous = calendar.date(byAdding: .month, value: -1, to: displayedMonth) else { return }
        displayedMonth = previous
        if let selectedDate, !calendar.isDate(selectedDate, equalTo: previous, toGranularity: .month) {
            self.selectedDate = nil
        }
    }

    func goToNextMonth() {
        guard let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) else { return }
        displayedMonth = next
        if let selectedDate, !calendar.isDate(selectedDate, equalTo: next, toGranularity: .month) {
            self.selectedDate = nil
        }
    }

    func dayText(for date: Date) -> String {
        String(calendar.component(.day, from: date))
    }

    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate else { return false }
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    private static func mapToCalendarEvents(_ listItems: [EventListItem]) -> [CalendarEventItem] {
        listItems.compactMap { item in
            guard let date = item.parsedDate else { return nil }
            return CalendarEventItem(title: item.title, time: item.time, date: date, kind: item.kind)
        }
    }
}
