import Foundation

extension Bundle {
  var appName: String {
    return object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
  }

  var appVersion: String {
    return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
  }

  var buildNumber: String {
    return object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
  }

  var appVersionInfo: String {
    "\(Bundle.main.appVersion)(\(Bundle.main.buildNumber))"
  }
}
