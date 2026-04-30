import SwiftUI

struct EventListFilterButtonView: View {
    @Binding var selectedFilter: EventListFilter

    var body: some View {
        Menu {
            ForEach(EventListFilter.allCases) { filter in
                Button {
                    selectedFilter = filter
                } label: {
                    if selectedFilter == filter {
                        Label(filter.rawValue, systemImage: "checkmark")
                    } else {
                        Text(filter.rawValue)
                    }
                }
            }
        } label: {
            HStack(spacing: screenHeight * 0.008) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: screenHeight * 0.017, weight: .semibold))
                Text("FILTERS")
                    .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.019))
            }
            .foregroundStyle(Color("appColor_2"))
            .padding(.horizontal, screenHeight * 0.02)
            .frame(height: screenHeight * 0.042)
            .background(
                Capsule()
                    .fill(Color("appColor_1"))
            )
        }
    }
}

#Preview {
    EventListFilterButtonView(selectedFilter: .constant(.byDate))
        .padding()
}
