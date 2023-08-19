//
//  Store.swift
//  ConnectUI
//
//  Created by will on 05/08/2023.
//

import AppStoreConnect_Swift_SDK
import Combine
import Foundation

class Store: ObservableObject {
  @Published var connectKeyModel: ConnectKeyModel = appDefaults[\.connectKeyModel] {
    didSet {
      appDefaults[\.connectKeyModel] = connectKeyModel
      updateAPIProvider()
    }
  }

  static let shared = Store()

  private init() {}

  func updateAPIProvider() {
    provider = APIProvider(
      configuration: APIConfiguration(
        issuerID: store.connectKeyModel.issuerID,
        privateKeyID: store.connectKeyModel.privateKeyID,
        privateKey: store.connectKeyModel.truePrivateKey
      ))
  }
}
