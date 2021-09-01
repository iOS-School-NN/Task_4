import Foundation

class UserSettings {
    private enum SettingsKeys: String {
        case saveIsEnabled
    }

    private static let userDefaults = UserDefaults.standard

    static var saveIsEnabled: Bool {
        get {

            return userDefaults.bool(forKey: SettingsKeys.saveIsEnabled.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: SettingsKeys.saveIsEnabled.rawValue)
        }
    }
}
