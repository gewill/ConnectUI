//
//  ConnectAPIProvider.swift
//  ConnectUI
//
//  Created by will on 05/08/2023.
//

import AppStoreConnect_Swift_SDK
import Foundation

/// Go to https://appstoreconnect.apple.com/access/api and create your own key. This is also the page to find the private key ID and the issuer ID.
/// Download the private key and open it in a text editor. Remove the enters and copy the contents over to the private key parameter.
// let configuration = APIConfiguration(
//  issuerID: Keys.issuerID,
//  privateKeyID: Keys.privateKeyID,
//  privateKey: Keys.privateKey
// )

// var provider: APIProvider = .init(configuration: configuration)
let store = Store.shared

var provider: APIProvider = .init(
  configuration: APIConfiguration(
    issuerID: store.connectKeyModel.issuerID,
    privateKeyID: store.connectKeyModel.privateKeyID,
    privateKey: store.connectKeyModel.truePrivateKey
  ))
