//
//  AppViewModel.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftUI

final class AppViewModel: ObservableObject {
  @Published var app: AppStoreConnect_Swift_SDK.App?

  var appId: String

  init(appId: String) {
    self.appId = appId
  }

  func loadApps() {
    Task.detached {
      let request = APIEndpoint
        .v1
        .apps
        .id(self.appId)
        .get()

      do {
        let app = try await provider.request(request).data
        await self.updateApp(to: app)
      } catch {
        print("Something went wrong fetching the apps: \(error.localizedDescription)")
      }
    }
  }

  @MainActor
  private func updateApp(to app: AppStoreConnect_Swift_SDK.App) {
    self.app = app
  }
}
