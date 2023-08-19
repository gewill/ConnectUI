//
//  Network.swift
//  iperfman
//
//  Created by will on 01/08/2023.
//

import Foundation
import SwiftyJSON

struct Network {
  var session = URLSession.shared

  func loadCurrencies(from url: URL = URL(string: "https://www.floatrates.com/daily/usd.json")!) async throws -> [CurrencyModel] {
    let (data, _) = try await session.data(from: url)
    let dic = JSON(data).dictionaryValue
    let result = dic.values.map { json in
      CurrencyModel(json: json)
    }
    return result
  }
}
