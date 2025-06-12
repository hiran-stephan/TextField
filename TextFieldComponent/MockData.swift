extension ManageAlertsAlertSettingsPresenter {
    func toChannelDataList() -> [ManageAlertChannelData] {
        contactTypeDataList().map { type in
            ManageAlertChannelData(
                primaryLabel: type.contactType.name,
                secondaryLabel: type.contactValue ?? "",
                isChecked: type.isSelected,
                state: .default // Add logic if you support other states
            )
        }
    }
}
