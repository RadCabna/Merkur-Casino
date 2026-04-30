import SwiftUI

struct EventDayCellView: View {
    let dayText: String
    let isSelected: Bool
    let isToday: Bool
    let eventKinds: [CalendarEventKind]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: screenHeight * 0.004) {
                Text(dayText)
                    .font(.custom(isToday ? "Montserrat-SemiBold" : "Montserrat-Medium", size: screenHeight * 0.026))
                    .foregroundStyle(Color("appColor_2"))
                    .frame(width: screenHeight * 0.045, height: screenHeight * 0.045)
                    .background(
                        Circle()
                            .fill(Color("appColor_1").opacity(isToday && !isSelected ? 0.35 : 0))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color("appColor_2"), lineWidth: 1)
                            .opacity(isSelected ? 1 : 0)
                    )

                HStack(spacing: screenHeight * 0.004) {
                    ForEach(Array(eventKinds.prefix(4).enumerated()), id: \.offset) { _, kind in
                        Circle()
                            .fill(color(for: kind))
                            .frame(width: screenHeight * 0.007, height: screenHeight * 0.007)
                    }
                }
                .frame(height: screenHeight * 0.009)
            }
            .frame(maxWidth: .infinity)
            .frame(height: screenHeight * 0.065)
        }
        .buttonStyle(.plain)
    }

    private func color(for kind: CalendarEventKind) -> Color {
        switch kind {
        case .vip:
            return Color("appColor_1")
        case .tournament:
            return Color("appColor_2")
        case .regular:
            return Color("appColor_4")
        }
    }
}

#Preview {
    EventDayCellView(dayText: "19", isSelected: true, isToday: false, eventKinds: [.vip, .tournament, .regular]) {
    }
    .padding()
}
