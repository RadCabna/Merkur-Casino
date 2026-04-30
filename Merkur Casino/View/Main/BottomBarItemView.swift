import SwiftUI

struct BottomBarItemView: View {
    let item: BottomMenuItem
    let isSelected: Bool
    let animationNamespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: screenHeight * 0.004) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color("appColor_1"))
                            .matchedGeometryEffect(id: "selectionCircle", in: animationNamespace)
                            .frame(width: screenHeight * 0.065, height: screenHeight * 0.065)
                    }

                    Image(isSelected ? item.activeIconName : item.inactiveIconName)
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: screenHeight * 0.03, height: screenHeight * 0.03)
                        .offset(y: isSelected ? -screenHeight * 0.002 : 0)
                }
                .frame(height: screenHeight * 0.02)

                if !isSelected {
                    Text(item.title)
                        .font(.system(size: screenHeight * 0.014, weight: .semibold))
                        .foregroundStyle(Color(red: 0.27, green: 0.36, blue: 0.47))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: screenHeight * 0.05)
            .offset(y: isSelected ? screenHeight * 0.00 : screenHeight * 0.002)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct BottomBarItemPreviewContainer: View {
    @Namespace private var namespace

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            HStack(spacing: 0) {
                BottomBarItemView(item: .home, isSelected: false, animationNamespace: namespace) {}
                BottomBarItemView(item: .event, isSelected: true, animationNamespace: namespace) {}
            }
            .padding()
            .background(Capsule().fill(.white))
            .padding()
        }
    }
}

#Preview {
    BottomBarItemPreviewContainer()
}
