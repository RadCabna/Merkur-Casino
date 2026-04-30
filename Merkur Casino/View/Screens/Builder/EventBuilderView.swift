import SwiftUI
import UIKit

struct EventBuilderView: View {
    @StateObject private var viewModel = EventBuilderViewModel()
    @StateObject private var eventStore = EventStore.shared
    @State private var isDatePickerPresented = false
    @State private var isStartTimePickerPresented = false
    @State private var isEndTimePickerPresented = false
    @State private var selectedImages: [UIImage] = []
    @State private var isSavedStateShown = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var showValidationErrors = false
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isLocationFocused: Bool
    @FocusState private var isPrizeFundFocused: Bool

    var body: some View {
        ScrollView(showsIndicators: false) {
            formContent
                .padding(.horizontal, screenHeight * 0.02)
                .padding(.bottom, keyboardInset)
        }
        .background(alignment: .top) {
            Image("bgMenu_3")
                .resizable()
                .scaledToFill()
                .frame(height: screenHeight * 3)
                .ignoresSafeArea()
        }
        .scrollDismissesKeyboard(.interactively)
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
            guard
                let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else {
                keyboardHeight = 0
                return
            }
            keyboardHeight = max(0, UIScreen.main.bounds.height - keyboardFrame.origin.y)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
        .alert("Saved", isPresented: $isSavedStateShown) {
            Button("OK", role: .cancel) {
            }
        } message: {
            Text("Event has been added.")
        }
    }

    private var formContent: some View {
        VStack(spacing: screenHeight * 0.026) {
            BuilderSectionTitleView(title: "Basic information")
                .padding(.top, screenHeight * 0.09)

            basicInfoSection

            BuilderSectionTitleView(title: "Parameters")

            parametersSection

            BuilderSectionTitleView(title: "Requirements")

            requirementsSection

            mediaAndVisibilitySection

            saveButton
                .padding(.bottom, screenHeight * 0.18)
        }
    }

    private var basicInfoSection: some View {
        VStack(spacing: screenHeight * 0.02) {
            BuilderInputFieldView(
                title: "Event Title",
                placeholder: "Enter event title",
                text: $viewModel.eventTitle,
                errorText: showValidationErrors && viewModel.eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Please fill this field" : nil,
                isFocused: $isTitleFocused
            )

            VStack(alignment: .leading, spacing: screenHeight * 0.009) {
                Text("Date")
                    .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                    .foregroundStyle(Color("appColor_2"))

                Button {
                    isDatePickerPresented = true
                } label: {
                    ZStack {
                        Text(viewModel.date.map { dateFormatter.string(from: $0) } ?? "YYYY-MM-DD")
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                            .foregroundStyle(Color("appColor_2"))
                            .frame(maxWidth: .infinity, alignment: .center)

                        HStack {
                            Spacer()
                            Image("calendarMark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenHeight * 0.027, height: screenHeight * 0.027)
                        }
                    }
                    .padding(.horizontal, screenHeight * 0.02)
                    .frame(height: screenHeight * 0.055)
                    .background(
                        RoundedRectangle(cornerRadius: screenHeight * 0.027)
                            .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                    )
                }
                .buttonStyle(.plain)
                .popover(isPresented: $isDatePickerPresented, attachmentAnchor: .rect(.bounds)) {
                    datePickerPopover
                        .presentationCompactAdaptation(.popover)
                }

                if showValidationErrors && viewModel.date == nil {
                    Text("Please select a date")
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.013))
                        .foregroundStyle(.red)
                }
            }

            VStack(alignment: .leading, spacing: screenHeight * 0.009) {
                Text("Time")
                    .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                    .foregroundStyle(Color("appColor_2"))

                HStack(spacing: screenHeight * 0.016) {
                    Button {
                        isStartTimePickerPresented = true
                    } label: {
                        Text(viewModel.startTime.map { timeFormatter.string(from: $0) } ?? "Start")
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                            .foregroundStyle(Color("appColor_2"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: screenHeight * 0.055)
                            .background(
                                RoundedRectangle(cornerRadius: screenHeight * 0.027)
                                    .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                            )
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $isStartTimePickerPresented, attachmentAnchor: .rect(.bounds)) {
                        startTimePickerPopover
                            .presentationCompactAdaptation(.popover)
                    }

                    Text("-")
                        .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.024))
                        .foregroundStyle(Color("appColor_2"))

                    Button {
                        isEndTimePickerPresented = true
                    } label: {
                        Text(viewModel.endTime.map { timeFormatter.string(from: $0) } ?? "End")
                            .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                            .foregroundStyle(Color("appColor_2"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: screenHeight * 0.055)
                            .background(
                                RoundedRectangle(cornerRadius: screenHeight * 0.027)
                                    .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                            )
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $isEndTimePickerPresented, attachmentAnchor: .rect(.bounds)) {
                        endTimePickerPopover
                            .presentationCompactAdaptation(.popover)
                    }
                }

                if showValidationErrors && viewModel.startTime == nil {
                    Text("Please select a time")
                        .font(.custom("Montserrat-Medium", size: screenHeight * 0.013))
                        .foregroundStyle(.red)
                }
            }

            BuilderInputFieldView(
                title: "Location",
                placeholder: "City and venue",
                text: $viewModel.location,
                errorText: showValidationErrors && viewModel.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Please fill this field" : nil,
                isFocused: $isLocationFocused
            )
        }
        .padding(screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02)
                .fill(.white.opacity(0.97))
        )
    }

    private var parametersSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.02) {
            Text("Event Type")
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                .foregroundStyle(Color("appColor_2"))

            flexibleEventTypeChips

            BuilderInputFieldView(
                title: "Buy-in",
                placeholder: "€50",
                text: $viewModel.buyIn
            )
            BuilderInputFieldView(
                title: "Prize Fund",
                placeholder: "$1,000",
                text: $viewModel.prizeFund,
                errorText: showValidationErrors && viewModel.prizeFund.filter(\.isNumber).isEmpty ? "Please fill this field" : nil,
                isFocused: $isPrizeFundFocused
            )
            BuilderInputFieldView(
                title: "Participants",
                placeholder: "Max participants",
                text: $viewModel.maxParticipants
            )
        }
        .padding(screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02)
                .fill(.white.opacity(0.97))
        )
    }

    private var flexibleEventTypeChips: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.012) {
            HStack(spacing: screenHeight * 0.012) {
                ForEach([EventType.tournament, .vipDinner, .promoAction], id: \.id) { type in
                    BuilderChoiceChipView(title: type.rawValue, isSelected: viewModel.selectedEventType == type) {
                        viewModel.selectedEventType = type
                    }
                }
                Spacer(minLength: 0)
            }

            HStack(spacing: screenHeight * 0.012) {
                BuilderChoiceChipView(title: EventType.privateGame.rawValue, isSelected: viewModel.selectedEventType == .privateGame) {
                    viewModel.selectedEventType = .privateGame
                }
                Spacer(minLength: 0)
            }
        }
    }

    private var requirementsSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.02) {
            Text("Dress Code")
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                .foregroundStyle(Color("appColor_2"))

            Menu {
                ForEach(DressCodeType.allCases) { dressCode in
                    Button(dressCode.rawValue) {
                        viewModel.selectedDressCode = dressCode
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedDressCode.rawValue)
                        .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.017))
                        .foregroundStyle(Color("appColor_2"))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.012))
                        .foregroundStyle(Color("appColor_2"))
                }
                .padding(.horizontal, screenHeight * 0.02)
                .frame(height: screenHeight * 0.055)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.027)
                        .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                )
            }

            Text("Description")
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                .foregroundStyle(Color("appColor_2"))

            TextEditor(text: $viewModel.description)
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                .foregroundStyle(Color("appColor_2"))
                .scrollContentBackground(.hidden)
                .padding(screenHeight * 0.012)
                .frame(height: screenHeight * 0.13)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.027)
                        .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
                )
                .overlay(alignment: .topLeading) {
                    if viewModel.description.isEmpty {
                        Text("Provide details about the rules, schedule, and expectations...")
                            .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                            .foregroundStyle(Color("appColor_2").opacity(0.75))
                            .padding(.horizontal, screenHeight * 0.017)
                            .padding(.vertical, screenHeight * 0.018)
                    }
                }
        }
        .padding(screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02)
                .fill(.white.opacity(0.97))
        )
    }

    private var mediaAndVisibilitySection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.02) {
            Text("Image")
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                .foregroundStyle(Color("appColor_2"))

            BuilderMediaPickerRowView(selectedImages: $selectedImages)

            Text("Visibility Settings")
                .font(.custom("Montserrat-Medium", size: screenHeight * 0.016))
                .foregroundStyle(Color("appColor_2"))

            VStack(spacing: screenHeight * 0.012) {
                visibilityButton(.public)
                visibilityButton(.vipOnly)
                visibilityButton(.invitationOnly)
            }
        }
        .padding(screenHeight * 0.02)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02)
                .fill(.white.opacity(0.97))
        )
    }

    private func visibilityButton(_ option: VisibilityType) -> some View {
        Button {
            viewModel.selectedVisibility = option
        } label: {
            HStack(spacing: screenHeight * 0.008) {
                Image(systemName: viewModel.selectedVisibility == option ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: screenHeight * 0.014))
                Text(option.rawValue)
                    .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.015))
                Spacer()
            }
            .foregroundStyle(Color("appColor_2"))
            .padding(.horizontal, screenHeight * 0.024)
            .frame(height: screenHeight * 0.06)
            .background(
                Capsule()
                    .fill(Color(red: 0.9, green: 0.92, blue: 0.95))
            )
        }
        .buttonStyle(.plain)
    }

    private var datePickerPopover: some View {
        VStack(spacing: 8) {
            DatePicker(
                "",
                selection: Binding(
                    get: { viewModel.date ?? Date() },
                    set: {
                        viewModel.date = $0
                        isDatePickerPresented = false
                    }
                ),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .tint(Color("appColor_2"))
        }
        .padding(10)
        .frame(width: 320, height: 330)
    }

    private var startTimePickerPopover: some View {
        DatePicker(
            "",
            selection: Binding(
                get: { viewModel.startTime ?? Date() },
                set: { viewModel.startTime = $0 }
            ),
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .tint(Color("appColor_2"))
        .padding(10)
        .frame(width: 220, height: 190)
    }

    private var endTimePickerPopover: some View {
        DatePicker(
            "",
            selection: Binding(
                get: { viewModel.endTime ?? Date() },
                set: { viewModel.endTime = $0 }
            ),
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .tint(Color("appColor_2"))
        .padding(10)
        .frame(width: 220, height: 190)
    }

    private var saveButton: some View {
        Button {
            guard viewModel.isSaveValid else {
                showValidationErrors = true
                focusFirstInvalidField()
                return
            }

            let bannerImagePath = selectedImages.first?
                .jpegData(compressionQuality: 0.9)
                .flatMap { eventStore.saveEventImageData($0) }

            if let event = viewModel.buildEvent(bannerImagePath: bannerImagePath) {
                eventStore.addEvent(event)
                viewModel.resetForm()
                selectedImages = []
                showValidationErrors = false
                clearTextFocus()
                isSavedStateShown = true
            }
        } label: {
            Text("Save")
                .font(.custom("Montserrat-SemiBold", size: screenHeight * 0.022))
                .foregroundStyle(Color("appColor_2").opacity(viewModel.isSaveValid ? 1 : 0.55))
                .frame(width: screenHeight * 0.2, height: screenHeight * 0.05)
                .background(
                    LinearGradient(
                        colors: [Color("gradientColor_1"), Color("gradientColor_2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(viewModel.isSaveValid ? 1 : 0.55)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var keyboardInset: CGFloat {
        keyboardHeight > 0 ? keyboardHeight + screenHeight * 0.02 : 0
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func focusFirstInvalidField() {
        clearTextFocus()
        guard let firstInvalid = viewModel.firstInvalidField else { return }
        switch firstInvalid {
        case .title:
            isTitleFocused = true
        case .date:
            isDatePickerPresented = true
        case .time:
            isStartTimePickerPresented = true
        case .location:
            isLocationFocused = true
        case .prizeFund:
            isPrizeFundFocused = true
        }
    }

    private func clearTextFocus() {
        isTitleFocused = false
        isLocationFocused = false
        isPrizeFundFocused = false
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "HH:mm"
    return formatter
}()

#Preview {
    EventBuilderView()
}
