import SwiftUI

enum EventPopupPointerPosition {
    case top
    case bottom
}

struct EventInfoPopupView: View {
    let events: [CalendarEventItem]
    let pointerOffsetX: CGFloat
    let pointerPosition: EventPopupPointerPosition

    var body: some View {
        Group {
            if pointerPosition == .top {
                VStack(spacing: 0) {
                    topPointer
                    content
                }
            } else {
                VStack(spacing: 0) {
                    content
                    bottomPointer
                }
            }
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                VStack(spacing: screenHeight * 0.01) {
                    Text(event.title)
                        .font(.custom("Montserrat-Bold", size: screenHeight * 0.02))
                        .foregroundStyle(Color("appColor_2"))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    HStack(spacing: screenHeight * 0.008) {
                        Image("calendarTimeIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenHeight * 0.019, height: screenHeight * 0.019)
                        Text(event.time)
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                            .foregroundStyle(Color("appColor_2"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, screenHeight * 0.018)
                .padding(.vertical, screenHeight * 0.012)

                if index < events.count - 1 {
                    Rectangle()
                        .fill(Color("appColor_2").opacity(0.22))
                        .frame(height: 1)
                        .padding(.horizontal, screenHeight * 0.012)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.014)
                .fill(Color("appColor_1"))
                .shadow(color: .black.opacity(0.14), radius: 10, x: 0, y: 5)
        )
    }

    private var topPointer: some View {
        TrianglePointer()
            .fill(Color("appColor_1"))
            .frame(width: screenHeight * 0.024, height: screenHeight * 0.014)
            .rotationEffect(.degrees(180))
            .offset(x: pointerOffsetX, y: 1)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }

    private var bottomPointer: some View {
        TrianglePointer()
            .fill(Color("appColor_1"))
            .frame(width: screenHeight * 0.024, height: screenHeight * 0.014)
            .offset(x: pointerOffsetX, y: -1)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

private struct TrianglePointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    EventInfoPopupView(events: [
        CalendarEventItem(title: "VIP Poker Night", time: "19:00", date: Date(), kind: .vip),
        CalendarEventItem(title: "Turbo Tournament", time: "20:30", date: Date(), kind: .tournament)
    ], pointerOffsetX: 0, pointerPosition: .bottom)
        .padding()
}
