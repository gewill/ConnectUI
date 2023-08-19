import CoreGraphics
import Foundation
import SwiftUI

enum LocaleConstants: String, CaseIterable, Identifiable {
  case system
  case en
  case zh_Hans = "zh-Hans"

  static let zhLanguageCode = "zh"

  var identifier: String {
    switch self {
    case .system: return Locale.current.language.languageCode?.identifier == LocaleConstants.zhLanguageCode ? LocaleConstants.zh_Hans.rawValue : LocaleConstants.en.rawValue
    case .en: return self.rawValue
    case .zh_Hans: return self.rawValue
    }
  }

  var title: LocalizedStringKey {
    switch self {
    case .system: return "Follow system"
    case .en: return "English"
    case .zh_Hans: return "简体中文"
    }
  }

  var id: LocaleConstants { self }
}

enum Theme: String, CaseIterable, Identifiable {
  case system, light, dark

  var colorScheme: ColorScheme? {
    switch self {
    case .system:
      return nil
    case .light:
      return .light
    case .dark:
      return .dark
    }
  }

  var title: LocalizedStringKey {
    switch self {
    case .system: return "Follow system"
    case .light: return "Light"
    case .dark: return "Dark"
    }
  }

  var id: Theme { self }
}

enum Constant {
#if os(macOS)
  static let padding: CGFloat = 16
  static let smallButtonSize: CGSize = .init(width: 30, height: 30)
#else
  static let padding: CGFloat = 12
  static let smallButtonSize: CGSize = .init(width: 40, height: 40)
#endif
  static let cornerRadius: CGFloat = 20
  static let maxiPhoneScreenWidth: CGFloat = 428
  static let maxiPhoneScreenHeight: CGFloat = 926
  static let tabBarHeight: CGFloat = 94
}

enum UserInterfaceIdiom: Int {
  case unspecified = -1
  case phone = 0
  case pad = 1
  case tv = 2
  case carPlay = 3
  case mac = 5
  case watch = 6

  static var current: UserInterfaceIdiom {
#if os(iOS)
    UserInterfaceIdiom(rawValue: UIDevice.current.userInterfaceIdiom.rawValue) ?? .unspecified
#elseif os(macOS)
    return .mac
#elseif os(watchOS)
    return .watch
#elseif os(tvOS)
    return .tv
#else
    return .unspecified
#endif
  }
}
