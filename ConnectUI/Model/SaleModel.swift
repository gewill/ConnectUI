//
//  SaleModel.swift
//  ConnectUI
//
//  Created by will on 2023/2/19.
//

import Foundation
import RealmSwift
import SwiftyJSON

/// 总计后的报告
struct SaleReportModel: Identifiable {
  enum ProductType: String {
    case saleApp, iap, total
  }

  let id: String
  let title: String
  let productType: ProductType
  let showDateRange: String
  var update: Int
  var units: Int
  /// 根据价格和汇率转换为美元
  var revenue: Double
}

/// 销售总报告 https://help.apple.com/app-store-connect/#/dev15f9508ca
/// 总计的手动计算，类型为total
class SaleModel: BaseModel {
  enum ProductType: String {
    case saleApp, saleBundle, update, redwonload, iap, unknown
  }

  @Persisted var id: String
  @Persisted var sku: String
  @Persisted var title: String
  /// 产品销量。负值表示退款；“CMB-C”表示先前购买 App 的 CMB 抵扣；“0”表示部分退款。
  @Persisted var units: Int
  /// 收入
  @Persisted var developerProceeds: Double
  /// 收入的货币种类
  @Persisted var currencyOfProceeds: String
  @Persisted var beginDate: String
  @Persisted var endDate: String
  @Persisted var productTypeIdentifier: String

  var productType: ProductType {
    switch productTypeIdentifier {
    case "1", "1E", "1EP", "1EU", "1F", "1T", "F1":
      return .saleApp
    case "1-B", "F1-B":
      return .saleBundle
    case "F7", "7T", "7F", "7":
      return .update
    case "3F", "3", "F3":
      return .redwonload
    case "FI1", "IA1", "IA1-M", "IA3", "IA9", "IA9-M", "IAY", "IAY-M":
      return .iap
    default: return .unknown
    }
  }

  // MARK: - Add by me
  @Persisted(indexed: true) var connectKeyId: String
  @Persisted(indexed: true) var day: String

  init(json: JSON) {
    id = json["Apple Identifier"].stringValue
    sku = json["SKU"].stringValue
    title = json["Title"].stringValue
    units = json["Units"].intValue
    developerProceeds = json["Developer Proceeds"].doubleValue
    currencyOfProceeds = json["Currency of Proceeds"].stringValue
    beginDate = json["Begin Date"].stringValue
    endDate = json["End Date"].stringValue
    productTypeIdentifier = json["Product Type Identifier"].stringValue
  }

  convenience init(dic: [String: String]) {
    self.init(json: JSON(dic))
  }

  override convenience init() {
    self.init(json: JSON.null)
  }
}

extension Double {
  func currencyString(code: String = "USD", simplifyZero: Bool = true) -> String {
    return formatted(.currency(code: code)
      .rounded()
      .precision(.fractionLength(0 ... 1))
      .decimalSeparator(strategy: .automatic)
      .presentation(.standard)
    )
  }
}
