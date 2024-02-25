//
//  ConnectKeyViewModel.swift
//  ConnectUI
//
//  Created by will on 05/08/2023.
//

import AppStoreConnect_Swift_SDK
import Foundation
import Gzip
import SwiftCSV
import SwiftUI

final class ConnectKeyViewModel: ObservableObject {
  enum TestState {
    case initial, testing, success, error(String)
  }

  @Published var csv: CSV<Named>?
  @Published var dailySaleModels: [SaleModel] = []
  @Published var selectedDate: Date = Date.now.addingTimeInterval(-60 * 60 * 24 * 4)

  @Published var errorMessage: String = ""
  @Published var testState: TestState = .initial

  // MARK: - life cycle

  @MainActor func loadApps() {
    let connectKeyModel = Store.shared.connectKeyModel
    do {
      let config = try APIConfiguration(
        issuerID: connectKeyModel.issuerID,
        privateKeyID: connectKeyModel.privateKeyID,
        privateKey: connectKeyModel.truePrivateKey
      )
      let provider = APIProvider(configuration: config)
      loadDailySales(provider: provider)
    } catch {
      updateTestState(.error(error.localizedDescription))
    }
  }
  
  func loadDailySales(provider: APIProvider) {
    Task.detached {
      await self.updateTestState(.testing)
      let request = APIEndpoint
        .v1
        .salesReports
        .get(parameters: .init(
          filterFrequency: [.daily],
          filterReportDate: [self.selectedDate.string()],
          filterReportSubType: [.summary],
          filterReportType: [.sales],
          filterVendorNumber: [store.connectKeyModel.vendorNumber]
        ))

      do {
        _ = try await provider.request(request)
        await self.updateTestState(.success)
      } catch {
        await self.updateTestState(.error(error.localizedDescription))
      }
    }
  }

  @MainActor
  private func updateTestState(_ state: TestState) {
    testState = state
    switch testState {
    case .initial:
      break
    case .testing:
      break
    case .success:
      store.connectKeyModel.isValid = true
    case .error:
      store.connectKeyModel.isValid = false
    }
  }
}
