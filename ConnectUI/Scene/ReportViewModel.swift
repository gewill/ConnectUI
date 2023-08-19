import AppStoreConnect_Swift_SDK
import Foundation
import Gzip
import RealmSwift
import SwiftCSV
import SwiftUI
import SwiftyJSON

@MainActor final class ReportViewModel: ObservableObject {
  @Published var totalSaleModel: SaleReportModel?
  @Published var dailySaleModels: [SaleReportModel] = []
  @AppStorage(UserDefaultsKeys.selectedDate.rawValue) var selectedDate: Date = Date.now.addingTimeInterval(Date.oneDayInSeconds * -2)
  
  @Published var errorMessage: String = ""
  @Published var showToast = false
  @Published var isLoadingPage = false
  
  @AppStorage(UserDefaultsKeys.reportRange.rawValue) var reportRange: ReportRange = .day1
  @AppStorage(UserDefaultsKeys.requestDataIgnoreCaches.rawValue) var requestDataIgnoreCaches: Bool = false
  @AppStorage(UserDefaultsKeys.lastCheckRatesDate.rawValue) var lastCheckRatesDate: TimeInterval = Date().yesterday.unixTimestamp
  
  var filterReportDate: [Date] {
    switch reportRange {
    case .day1:
      return (0 ... 0)
        .map { selectedDate.addingTimeInterval(Date.oneDayInSeconds * Double($0)) }
    case .day7:
      return (-6 ... 0)
        .map { selectedDate.addingTimeInterval(Date.oneDayInSeconds * Double($0)) }
    case .day30:
      return (-29 ... 0)
        .map { selectedDate.addingTimeInterval(Date.oneDayInSeconds * Double($0)) }
    case .thisMonth:
      let day = -(selectedDate.day - 1)
      return (day ... 0)
        .map { selectedDate.addingTimeInterval(Date.oneDayInSeconds * Double($0)) }
    }
  }
  
  let realm = RealmProvider.main.realm
  var saleModels: Results<SaleModel>!
  var currencyModels: Results<CurrencyModel>!
  
  var task: Task<Void, Never>?
  var token: NotificationToken?
  
  // MARK: - life cycle
  
  init() {
    updateSaleModelWhere()
    currencyModels = realm.objects(CurrencyModel.self)
    getRates()
    token = currencyModels.observe { [weak self] _ in
      guard let self else { return }
      self.calSum()
    }
  }
  
  /*
   Doc https://developer.apple.com/documentation/appstoreconnectapi/download_sales_and_trends_reports
   
   https://developer.apple.com/help/app-store-connect/reference/sales-and-trends-reports-availability
   Sales and Trends reports availability
   Sales and Trends reports are available to download at the following times:
   
   Daily reports are available the following day.
   Weekly reports are available on Mondays.
   Monthly reports are available five days after the end of the month.
   Yearly reports are available six days after the end of the year.
   
   Reports are generally available by 8 a.m. Pacific Time (PT).
   北京的晚上11:00
   */
  
  func loadApps() {
    guard store.connectKeyModel.isValid else {
      return
    }
    
    updateSaleModelWhere()
    cancelTask()
    
    task = Task {
      guard !self.isLoadingPage else {
        return
      }
      
      self.isLoadingPage = true
      
      do {
        _ = try await self.loadAllSales()
        //        self.saveApps(models: models)
        self.calSum()
      } catch {
        self.showError(message: "Request sales reports error: \(error.localizedDescription)")
      }
      self.isLoadingPage = false
    }
  }
  
  func resetApps() {
    totalSaleModel = nil
    dailySaleModels = []
  }
  
  func cancelTask() {
    isLoadingPage = false
    task?.cancel()
  }
  
  // MARK: - private methods
  
  private func loadAllSales() async throws -> [SaleModel] {
    try await filterReportDate.reversed()
      .asyncReduce([SaleModel]()) { result, date in
        var result = result
        try result.append(contentsOf: await loadDailySales(date: date))
        return result
      }
  }
  
  private func checkCaches(date: Date) -> Bool {
    let oldModelsCount = realm.objects(SaleModel.self).where {
      $0.day == date.string()
        && $0.connectKeyId == store.connectKeyModel.id
    }.count
    return oldModelsCount > 0
  }
  
  private func loadDailySales(date: Date) async throws -> [SaleModel] {
    guard requestDataIgnoreCaches || checkCaches(date: date) == false else {
      return []
    }
    
    let request = APIEndpoint
      .v1
      .salesReports
      .get(parameters: .init(
        filterFrequency: [.daily],
        filterReportDate: [date.string()],
        filterReportSubType: [.summary],
        filterReportType: [.sales],
        filterVendorNumber: [store.connectKeyModel.vendorNumber]
      ))
    let gz = try await provider.request(request)
    let data = try gz.gunzipped()
    var result = [SaleModel]()
    if let string = String(data: data, encoding: .utf8) {
      let csv = try CSV<Named>.init(string: string, delimiter: .tab)
      let models = csv.rows.compactMap { dic in
        let model = SaleModel(dic: dic)
        model.connectKeyId = store.connectKeyModel.id
        model.day = date.string()
        return model
      }
      result = models
    }
    saveDailyApps(date: date, models: result)
    return result
  }
  
  @MainActor
  private func updateApps(models: [SaleModel]) {
    // SKU分组
    let dic = Dictionary(grouping: models) { model in
      model.sku
    }
    let showDateRange: String
    if reportRange == .day1 {
      showDateRange = selectedDate.string()
    } else {
      showDateRange = filterReportDate.first!.string()
        + " - "
        + selectedDate.string()
    }
    
    dailySaleModels = dic.keys
      .compactMap { sku -> SaleReportModel? in
        if let models = dic[sku],
           let first = models.first
        {
          let reportModel = SaleReportModel(id: first.id, title: first.title, productType: first.productType == .iap ? .iap : .saleApp, showDateRange: showDateRange, update: 0, units: 0, revenue: 0)
          let total = models.reduce(into: reportModel) { partialResult, model in
            switch model.productType {
            case .saleApp, .saleBundle:
              partialResult.units += model.units
              partialResult.revenue += model.developerProceeds * Double(model.units) / getRate(model.currencyOfProceeds)
            case .update:
              partialResult.update += model.units
            case .iap:
              partialResult.revenue += model.developerProceeds * Double(model.units) / getRate(model.currencyOfProceeds)
              partialResult.units += model.units
            default: break
            }
          }
          return total
        }
        return nil
      }
      .sorted(by: { $0.title < $1.title })
      .sorted(by: { $0.revenue > $1.revenue })
    var total = SaleReportModel(id: "Total", title: "Total", productType: .total, showDateRange: showDateRange, update: 0, units: 0, revenue: 0)
    dailySaleModels.forEach { model in
      total.units += model.units
      total.update += model.update
      total.revenue += model.revenue
    }
    totalSaleModel = total
  }
  
  func getRate(_ code: String) -> Double {
    let currency = realm.object(ofType: CurrencyModel.self, forPrimaryKey: code)
    return currency?.rate ?? 1
  }
  
  func getRates() {
    lastCheckRatesDate = Date().yesterday.unixTimestamp
    if Date().yesterday.unixTimestamp >= lastCheckRatesDate {
      Task {
        do {
          let currencies = try await Network().loadCurrencies()
          self.updateCurrencies(currencies: currencies)
          lastCheckRatesDate = Date().unixTimestamp
        } catch {
          print("Request failed with error: \(error)")
          self.loadRatesJSON()
        }
      }
    }
  }
  
  func updateCurrencies(currencies: [CurrencyModel]) {
    if currencies.isEmpty {
      loadRatesJSON()
    } else {
      saveCurrencies(currencies: currencies)
    }
  }
  
  func loadRatesJSON() {
    guard currencyModels.count == 0 else { return }

    if let url = Bundle.main.url(forResource: "currency", withExtension: "json"),
       let data = try? Data(contentsOf: url)
    {
      let dic = JSON(data).dictionaryValue
      let result = dic.values.map { json in
        CurrencyModel(json: json)
      }
      saveCurrencies(currencies: result)
    }
  }

  @MainActor
  private func showError(message: String) {
    errorMessage = message
    showToast = true
    print(errorMessage)
    resetApps()
  }

  // MARK: - Realm

  func updateSaleModelWhere() {
    saleModels = realm.objects(SaleModel.self).where {
      $0.day.in(filterReportDate.map { date in date.string() })
        && $0.connectKeyId == store.connectKeyModel.id
    }
  }

//  @MainActor
//  private func saveApps(models: [SaleModel]) {
//    realm.writeAsync {
//      self.realm.delete(self.saleModels)
//      self.realm.add(models)
//    } onComplete: { _ in
//      self.calSum()
//    }
//  }

  @MainActor
  private func saveDailyApps(date: Date, models: [SaleModel]) {
    let oldModels = realm.objects(SaleModel.self).where {
      $0.day == date.string()
        && $0.connectKeyId == store.connectKeyModel.id
    }
    realm.writeAsync {
      self.realm.delete(oldModels)
      self.realm.add(models)
    } onComplete: { _ in
      self.calSum()
    }
  }

  func calSum() {
    updateApps(models: Array(saleModels))
  }
  
  func saveCurrencies(currencies: [CurrencyModel]) {
    realm.writeAsync {
      self.realm.add(currencies, update: .all)
    } onComplete: { _ in
      self.calSum()
    }
  }
}
