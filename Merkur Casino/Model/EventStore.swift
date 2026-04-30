import Combine
import Foundation

final class EventStore: ObservableObject {
    static let shared = EventStore()

    @Published private(set) var events: [EventListItem]
    @Published private(set) var registeredEventIDs: Set<String>

    private let defaults = UserDefaults.standard
    private let eventsKey = "stored_events_v1"
    private let registeredKey = "stored_registered_event_ids_v1"
    private let registrationResetAppliedKey = "registration_reset_applied_v1"

    private init() {
        if
            let data = defaults.data(forKey: eventsKey),
            let decoded = try? JSONDecoder().decode([EventListItem].self, from: data),
            !decoded.isEmpty {
            events = decoded
        } else {
            events = EventCatalog.defaultEvents
        }

        if
            let data = defaults.data(forKey: registeredKey),
            let decoded = try? JSONDecoder().decode([String].self, from: data) {
            registeredEventIDs = Set(decoded)
        } else {
            registeredEventIDs = []
        }

        if !defaults.bool(forKey: registrationResetAppliedKey) {
            registeredEventIDs = []
            persistRegisteredIDs()
            defaults.set(true, forKey: registrationResetAppliedKey)
        }
    }

    func register(eventId: String) {
        registeredEventIDs.insert(eventId)
        persistRegisteredIDs()
    }

    func isRegistered(eventId: String) -> Bool {
        registeredEventIDs.contains(eventId)
    }

    func addEvent(_ event: EventListItem) {
        events.append(event)
        persistEvents()
    }

    func saveEventImageData(_ data: Data) -> String? {
        let fileName = "event_\(UUID().uuidString.lowercased()).jpg"
        let url = documentsDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: url, options: .atomic)
            return fileName
        } catch {
            return nil
        }
    }

    func imageURL(for relativePath: String) -> URL {
        documentsDirectory.appendingPathComponent(relativePath)
    }

    private func persistEvents() {
        if let data = try? JSONEncoder().encode(events) {
            defaults.set(data, forKey: eventsKey)
        }
    }

    private func persistRegisteredIDs() {
        let ids = Array(registeredEventIDs)
        if let data = try? JSONEncoder().encode(ids) {
            defaults.set(data, forKey: registeredKey)
        }
    }

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: NSTemporaryDirectory())
    }
}
