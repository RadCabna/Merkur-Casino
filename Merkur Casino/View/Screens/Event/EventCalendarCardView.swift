import SwiftUI

struct EventCalendarCardView: View {
    @ObservedObject var viewModel: EventCalendarViewModel

    private let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding = screenHeight * 0.018
            let cardWidth = geometry.size.width
            let gridWidth = cardWidth - horizontalPadding * 2
            let cellWidth = gridWidth / 7
            let selectedIndex = selectedDateIndex(in: viewModel.daysInGrid)
            let selectedColumn = CGFloat((selectedIndex ?? 0) % 7)
            let selectedRow = CGFloat((selectedIndex ?? 0) / 7)
            let popupWidth = screenHeight * 0.34
            let popupXRaw = -gridWidth / 2 + cellWidth * (selectedColumn + 0.5)
            let popupHorizontalLimit = (cardWidth - popupWidth) / 2 - screenHeight * 0.008
            let popupX = min(max(popupXRaw, -popupHorizontalLimit), popupHorizontalLimit)
            let pointerOffsetLimit = popupWidth / 2 - screenHeight * 0.03
            let pointerOffsetX = min(max(popupXRaw - popupX, -pointerOffsetLimit), pointerOffsetLimit)
            let gridStartY = screenHeight * 0.11
            let cellHeight = screenHeight * 0.065
            let selectedCellCenterY = gridStartY + selectedRow * cellHeight + cellHeight / 2
            let pointerHeight = screenHeight * 0.014
            let popupContentHeight = screenHeight * 0.12 + CGFloat(max(viewModel.selectedEvents.count - 1, 0)) * screenHeight * 0.072
            let popupTotalHeight = popupContentHeight + pointerHeight
            let gap = -screenHeight * 0.02
            let selectedCellTopY = selectedCellCenterY - cellHeight / 2
            let selectedCellBottomY = selectedCellCenterY + cellHeight / 2
            let popupYAbove = selectedCellTopY - gap - popupTotalHeight
            let popupYBelow = selectedCellBottomY + gap
            let canShowAbove = popupYAbove >= screenHeight * 0.02
            let popupY = canShowAbove ? popupYAbove : popupYBelow
            let pointerPosition: EventPopupPointerPosition = canShowAbove ? .bottom : .top

            VStack(spacing: 0) {
                header
                    .padding(.top, screenHeight * 0.02)
                    .padding(.horizontal, horizontalPadding)

                weekdayRow
                    .padding(.top, screenHeight * 0.022)
                    .padding(.horizontal, horizontalPadding)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                    ForEach(Array(viewModel.daysInGrid.enumerated()), id: \.offset) { _, date in
                        if let date {
                            EventDayCellView(
                                dayText: viewModel.dayText(for: date),
                                isSelected: viewModel.isSelected(date),
                                isToday: viewModel.isToday(date),
                                eventKinds: viewModel.eventsForDate(date).map(\.kind)
                            ) {
                                viewModel.select(date: date)
                            }
                        } else {
                            Color.clear
                                .frame(height: screenHeight * 0.065)
                        }
                    }
                }
                .padding(.top, screenHeight * 0.012)
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, screenHeight * 0.018)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                RoundedRectangle(cornerRadius: screenHeight * 0.03)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
            )
            .overlay(alignment: .top) {
                if !viewModel.selectedEvents.isEmpty, selectedIndex != nil {
                    EventInfoPopupView(
                        events: viewModel.selectedEvents,
                        pointerOffsetX: pointerOffsetX,
                        pointerPosition: pointerPosition
                    )
                        .frame(width: popupWidth)
                        .offset(x: popupX, y: popupY)
                }
            }
        }
        .frame(height: screenHeight * 0.44)
    }

    private var header: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.goToPreviousMonth()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: screenHeight * 0.018, weight: .semibold))
                    .foregroundStyle(Color("appColor_2").opacity(0.35))
            }
            .buttonStyle(.plain)

            Spacer()

            Text(viewModel.monthTitle)
                .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                .foregroundStyle(Color("appColor_2"))

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.goToNextMonth()
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: screenHeight * 0.018, weight: .semibold))
                    .foregroundStyle(Color("appColor_2").opacity(0.35))
            }
            .buttonStyle(.plain)
        }
    }

    private var weekdayRow: some View {
        HStack(spacing: 0) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.custom("Montserrat-Medium", size: screenHeight * 0.014))
                    .foregroundStyle(Color("appColor_2").opacity(0.6))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func selectedDateIndex(in grid: [Date?]) -> Int? {
        guard let selectedDate = viewModel.selectedDate else { return nil }
        return grid.firstIndex { date in
            guard let date else { return false }
            return Calendar(identifier: .gregorian).isDate(date, inSameDayAs: selectedDate)
        }
    }
}

#Preview {
    EventCalendarCardView(viewModel: EventCalendarViewModel())
        .padding()
}
