//
//  StringExtensions.swift
//  iperfman
//
//  Created by will on 2022/12/13.
//

import Foundation
import SwiftUI

extension String {
  var localizedStringKey: LocalizedStringKey {
    LocalizedStringKey(stringLiteral: self)
  }

  static var noValueSymbol = "--"

  func replaceEmpty(with str: String = .noValueSymbol) -> String {
    self.isEmpty ? str : self
  }

  // https://www.hangge.com/blog/cache/detail_1583.html
  // 将原始的url编码为合法的url
  func urlEncoded() -> String {
    let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
      .urlQueryAllowed)
    return encodeUrlString ?? ""
  }

  // 将编码后的url转换回原始的url
  func urlDecoded() -> String {
    return self.removingPercentEncoding ?? ""
  }

  func dateTime(withFormat format: String = "yyyy-MM-dd") -> Date? {
    let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = format
    return formatter.date(from: selfLowercased)
  }
}
