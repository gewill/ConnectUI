import Foundation
import SwiftUI

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }

    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }

  /// SwifterSwift: Hexadecimal value string (read-only).
  var hexString: String {
    let components: [Int] = {
      let comps = cgColor?.components?.map { Int($0 * 255.0) } ?? []
      guard comps.count != 4 else { return comps }
      return [comps[0], comps[0], comps[0], comps[1]]
    }()
    return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
  }
}

extension Color {
  enum Gradient {
    static let noonToDusk = [Color(hex: "FF6E7F"), Color(hex: "BFE9FF")]
    static let kashmir = [Color(hex: "614385"), Color(hex: "516395")]
    static let deepSpace = [Color(hex: "000000"), Color(hex: "434343")]
    static let gradeGrey = [Color(hex: "BDC3C7"), Color(hex: "2C3E50")]
  }
}
