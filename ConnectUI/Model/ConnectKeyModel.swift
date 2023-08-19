//
//  Keys.swift
//  ConnectUI
//
//  Created by will on 2023/2/19.
//

import Foundation
import SwiftyUserDefaults

// enum Keys {
//  static let issuerID = "69a6de84-b2aa-47e3-e053-5b8c7c11a4d1"
//  static let vendorNumber = "86592995"
//  static let privateKeyID = "B23J26YZ58"
//  static let privateKey = getPrivateKey()
// }

func getPrivateKey() -> String {
  guard let path = Bundle.main.path(forResource: "privateKey", ofType: "txt"),
        let text: String = try? String(contentsOfFile: path)
  else {
    return ""
  }
  return text.replacing("\n", with: "")
}

struct ConnectKeyModel: Codable, DefaultsSerializable {
  var issuerID: String = ""
  var vendorNumber: String = ""
  var privateKeyID: String = ""
  var privateKey: String = ""
  var isValid: Bool = false

  var truePrivateKey: String {
    privateKey
      .replacing("\n", with: "")
      .replacing("-----BEGIN PRIVATE KEY-----", with: "")
      .replacing("-----END PRIVATE KEY-----", with: "")
  }

  var id: String {
    issuerID + "_" + vendorNumber + "_" + privateKeyID
  }
}
