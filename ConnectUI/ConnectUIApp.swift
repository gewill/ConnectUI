//
//  ConnectUIApp.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import FileKit
import SwiftUI

@main
struct ConnectUIApp: App {
  let store = Store.shared
  @AppStorage(UserDefaultsKeys.selectedLocale.rawValue) var selectedLocale: LocaleConstants = .system

  // MARK: - life cycle

  init() {
    print("📦: \(Path.userDocuments)")
  }

  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(store)
        .environment(\.locale, Locale(identifier: selectedLocale.identifier))
        .environment(\.realmConfiguration, RealmProvider.main.configuration)
    }
  }
}
