//
//  ReportRange.swift
//  ConnectUI
//
//  Created by will on 05/08/2023.
//

import Foundation
import SwiftyUserDefaults

enum ReportRange: String, CaseIterable, Codable, DefaultsSerializable, Identifiable {
  case day1, day7, day30, thisMonth

  var id: ReportRange { self }
}
