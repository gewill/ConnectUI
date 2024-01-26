import SwiftyUserDefaults

let appDefaults = Defaults

extension DefaultsKeys {
  var connectKeyModel: DefaultsKey<ConnectKeyModel> { .init(UserDefaultsKeys.connectKeyModel.rawValue, defaultValue: ConnectKeyModel()) }
}

enum UserDefaultsKeys: String {
  case connectKeyModel
  case reportRange
  case selectedLocale
  case requestDataIgnoreCaches
  case lastCheckRatesDate
  case selectedDate
  case showColorOptions
  case foregroundColorHex
  case colorSpeed
  case colorNoise
  case colorTransitionInterval
}
