import AVFoundation
import ImageIO
import PhotosUI
import SwiftUI
import UIKit

struct PersonalProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("logged_user_name") private var userName = "Slon"
    @AppStorage("is_user_logged_in") private var isUserLoggedIn = false
    @AppStorage("profile_image_data") private var profileImageData: Data = Data()

    @StateObject private var homeViewModel = HomeViewModel()
    @State private var draftName = ""
    @State private var isEditingName = false
    @FocusState private var isNameFieldFocused: Bool
    @State private var isLogoutDialogShown = false
    @State private var isSourceDialogShown = false
    @State private var isCameraPermissionAlertShown = false
    @State private var isCameraPickerPresented = false
    @State private var isGalleryPickerPresented = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var profileCGImage: CGImage?

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: screenHeight * 0.02) {
                    header
                    profileBlock

                    HomeLevelCardView(
                        levelTitle: homeViewModel.levelTitle,
                        currentXP: homeViewModel.currentXP,
                        nextLevelXP: homeViewModel.nextLevelXP
                    )

                    statsGrid

                    logoutButton
                        .padding(.top, screenHeight * 0.01)
                }
                .padding(.horizontal, screenHeight * 0.02)
                .padding(.top, screenHeight * 0.07)
                .padding(.bottom, screenHeight * 0.06)
            }
            .onTapGesture {
                if isEditingName {
                    saveName()
                }
            }
            .opacity(isLogoutDialogShown ? 0.28 : 1)
            .allowsHitTesting(!isLogoutDialogShown)

            if isLogoutDialogShown {
                PersonalLogoutDialogView {
                    isUserLoggedIn = false
                    isLogoutDialogShown = false
                    dismiss()
                } onCancel: {
                    isLogoutDialogShown = false
                }
                .padding(.horizontal, screenHeight * 0.02)
                .padding(.top, screenHeight * 0.2)
            }
        }
        .background {
            Image("easyBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .confirmationDialog("Choose Source", isPresented: $isSourceDialogShown, titleVisibility: .visible) {
            Button("Camera") {
                requestCameraPermission()
            }
            Button("Gallery") {
                isGalleryPickerPresented = true
            }
            Button("Cancel", role: .cancel) {
            }
        }
        .photosPicker(isPresented: $isGalleryPickerPresented, selection: $selectedPhotoItem, matching: .images)
        .alert("Camera Access", isPresented: $isCameraPermissionAlertShown) {
            Button("OK", role: .cancel) {
            }
        } message: {
            Text("Allow camera access in system settings to use this source.")
        }
        .sheet(isPresented: $isCameraPickerPresented) {
            PersonalCameraPickerView { image in
                let normalized = image.normalizedOrientation()
                if let data = normalized.jpegData(compressionQuality: 0.9) {
                    profileImageData = data
                    loadProfileCGImage()
                }
            }
            .ignoresSafeArea()
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    profileImageData = data
                    loadProfileCGImage()
                }
                selectedPhotoItem = nil
            }
        }
        .onChange(of: profileImageData) { _, _ in
            loadProfileCGImage()
        }
        .onAppear {
            draftName = userName
            loadProfileCGImage()
        }
    }

    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: screenHeight * 0.03, weight: .medium))
                    .foregroundStyle(Color("appColor_2"))
            }
            .buttonStyle(.plain)

            Spacer()

            Text("MY PROFILE")
                .font(.custom("Montserrat-Bold", size: screenHeight * 0.028))
                .foregroundStyle(Color("appColor_2"))
                .frame(width: screenHeight * 0.2, height: screenHeight * 0.045)
                .background(Color("appColor_1"))

            Spacer()
            Color.clear.frame(width: screenHeight * 0.03)
        }
    }

    private var profileBlock: some View {
        VStack(spacing: screenHeight * 0.01) {
            Button {
                isSourceDialogShown = true
            } label: {
                profileImageContent
            }
            .buttonStyle(.plain)

            HStack(spacing: screenHeight * 0.01) {
                if isEditingName {
                    TextField("", text: $draftName)
                        .font(.custom("Montserrat-Bold", size: screenHeight * 0.04))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .focused($isNameFieldFocused)
                        .onSubmit { saveName() }
                } else {
                    Text(userName)
                        .font(.custom("Montserrat-Bold", size: screenHeight * 0.04))
                        .foregroundStyle(.white)
                }

                Button {
                    if isEditingName {
                        saveName()
                    } else {
                        isEditingName = true
                        isNameFieldFocused = true
                    }
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: screenHeight * 0.02, weight: .medium))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var profileImageContent: some View {
        if let image = imageFromProfileData {
            Circle()
                .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                .frame(width: screenHeight * 0.12, height: screenHeight * 0.12)
                .overlay(
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                )
        } else {
            Image("profileAvatarIcon")
                .resizable()
                .scaledToFit()
                .frame(width: screenHeight * 0.14, height: screenHeight * 0.14)
        }
    }

    private var imageFromProfileData: Image? {
        guard let profileCGImage else { return nil }
        return Image(decorative: profileCGImage, scale: 1)
    }

    private var statsGrid: some View {
        VStack(spacing: screenHeight * 0.016) {
            HStack(spacing: screenHeight * 0.016) {
                PersonalStatsCardView(iconName: "profileTotalIcon", value: "\(homeViewModel.currentXP)", title: "TOTAL POINTS")
                PersonalStatsCardView(iconName: "profileEventIcon", value: "24", title: "EVENTS ATTENDED")
            }
            HStack(spacing: screenHeight * 0.016) {
                PersonalStatsCardView(iconName: "profileTournamentIcon", value: "8", title: "TOURNAMENTS WON")
                PersonalStatsCardView(iconName: "profileBonusIcon", value: "15", title: "BONUSES CLAIMED")
            }
        }
    }

    private var logoutButton: some View {
        Button {
            isLogoutDialogShown = true
        } label: {
            HStack(spacing: screenHeight * 0.008) {
                Image(systemName: "arrow.right.square")
                Text("Log Out")
                    .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.024))
            }
            .foregroundStyle(Color.red.opacity(0.65))
            .frame(maxWidth: .infinity)
            .frame(height: screenHeight * 0.058)
            .overlay(
                RoundedRectangle(cornerRadius: screenHeight * 0.029)
                    .stroke(Color.red, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private func saveName() {
        let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            userName = trimmed
        }
        draftName = userName
        isEditingName = false
        isNameFieldFocused = false
    }

    private func requestCameraPermission() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            isCameraPermissionAlertShown = true
            return
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraPickerPresented = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isCameraPickerPresented = true
                    } else {
                        isCameraPermissionAlertShown = true
                    }
                }
            }
        case .denied, .restricted:
            isCameraPermissionAlertShown = true
        @unknown default:
            isCameraPermissionAlertShown = true
        }
    }

    private func loadProfileCGImage() {
        guard !profileImageData.isEmpty else {
            profileCGImage = nil
            return
        }
        guard
            let source = CGImageSourceCreateWithData(profileImageData as CFData, nil),
            let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            profileCGImage = nil
            return
        }
        profileCGImage = image
    }
}

private struct PersonalCameraPickerView: UIViewControllerRepresentable {
    let onImagePicked: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked, dismiss: dismiss)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let onImagePicked: (UIImage) -> Void
        let dismiss: DismissAction

        init(onImagePicked: @escaping (UIImage) -> Void, dismiss: DismissAction) {
            self.onImagePicked = onImagePicked
            self.dismiss = dismiss
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                onImagePicked(image)
            }
            dismiss()
        }
    }
}

private extension UIImage {
    func normalizedOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

#Preview {
    PersonalProfileView()
}
