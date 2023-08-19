//
//  Currency.swift
//  ConnectUI
//
//  Created by will on 2023/2/19.
//

import Foundation
import RealmSwift
import SwiftyJSON

/// https://www.floatrates.com/json-feeds.html
/// 需要缓存，更新通知
struct CurrencyModelTool {
  static func getRate(_ code: String) -> Double {
    CurrencyModelTool.getCurrencyModel().first(where: { $0.code == code })?.rate ?? 1
  }

  static func getCurrencyModel() -> [CurrencyModel] {
    if let url = Bundle.main.url(forResource: "currency", withExtension: "json"),
       let data = try? Data(contentsOf: url)
    {
      let dic = JSON(data).dictionaryValue
      return dic.values.map { json in
        CurrencyModel(json: json)
      }
    }
    return []
  }
}

class CurrencyModel: Object {
  @Persisted var alphaCode: String
  @Persisted var code: String
  @Persisted var date: String
  @Persisted var inverseRate: Double
  @Persisted var name: String
  @Persisted var numericCode: String
  @Persisted var rate: Double
  
  override static func primaryKey() -> String? {
    return "code"
  }

  init(json: JSON) {
    super.init()

    alphaCode = json["alphaCode"].stringValue
    code = json["code"].stringValue
    date = json["date"].stringValue
    inverseRate = json["inverseRate"].doubleValue
    name = json["name"].stringValue
    numericCode = json["numericCode"].stringValue
    rate = json["rate"].doubleValue
  }

  override convenience init() {
    self.init(json: JSON.null)
  }
}
