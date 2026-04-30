import SwiftUI

struct BuilderMediaPickerRowView: View {
    @Binding var selectedImages: [UIImage]
    @State private var isPhotoPickerPresented = false

    private let maxImagesCount = 4
    private var itemSpacing: CGFloat { screenHeight * 0.016 }
    private var preferredItemSize: CGFloat { screenHeight * 0.09 }

    var body: some View {
        GeometryReader { proxy in
            let totalSpacing = itemSpacing * CGFloat(maxImagesCount - 1)
            let adaptiveItemSize = min(
                preferredItemSize,
                (proxy.size.width - totalSpacing) / CGFloat(maxImagesCount)
            )

            HStack(spacing: itemSpacing) {
                if selectedImages.count < maxImagesCount {
                    Button {
                        isPhotoPickerPresented = true
                    } label: {
                        Image("imagePlaceholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: adaptiveItemSize, height: adaptiveItemSize)
                    }
                    .buttonStyle(.plain)
                }

                ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                    RoundedRectangle(cornerRadius: screenHeight * 0.02)
                        .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                        .frame(width: adaptiveItemSize, height: adaptiveItemSize)
                        .overlay {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: adaptiveItemSize, height: adaptiveItemSize)
                                .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.02))
                        }
                        .overlay(alignment: .topTrailing) {
                            Button {
                                selectedImages.remove(at: index)
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(.red)
                                        .frame(width: screenHeight * 0.018, height: screenHeight * 0.018)
                                    Image(systemName: "xmark")
                                        .font(.system(size: screenHeight * 0.008, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .buttonStyle(.plain)
                            .offset(x: screenHeight * 0.006, y: -screenHeight * 0.006)
                        }
                }

                Spacer(minLength: 0)
            }
        }
        .frame(height: preferredItemSize)
        .fullScreenCover(isPresented: $isPhotoPickerPresented) {
            FullScreenPhotoPickerView(maxSelectionCount: maxImagesCount - selectedImages.count) { images in
                let availableSlots = maxImagesCount - selectedImages.count
                guard availableSlots > 0 else { return }
                selectedImages.append(contentsOf: Array(images.prefix(availableSlots)))
            }
        }
    }
}

#Preview {
    BuilderMediaPickerRowView(selectedImages: .constant([]))
        .padding()
}
