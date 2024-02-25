//
//  AppsListViewModel.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import AppStoreConnect_Swift_SDK
import SwiftUI

final class AppsListViewModel: ObservableObject {
  @Published var apps: [AppStoreConnect_Swift_SDK.App] = []

  let store = Store.shared
  
  // MARK: - life cycle

  // MARK: - methods

  func loadApps() {
    guard let provider = provider else { return }
    Task.detached {
      let request = APIEndpoint
        .v1
        .apps
        .get(parameters: .init(
          sort: [.bundleID],
          fieldsApps: [.appInfos, .name, .bundleID, .sku],
          limit: nil
        ))

      do {
        let apps = try await provider.request(request).data
        await self.updateApps(to: apps)
      } catch {
        print("Something went wrong fetching the apps: \(error.localizedDescription)")
      }
    }
  }

  /// This demonstrates a failing example and how you can catch error details.
  func loadFailureExample() {
    guard let provider = provider else { return }
    Task.detached {
      let requestWithError = APIEndpoint
        .v1
        .builds
        .id("app.appId")
        .get()

      do {
        try print(await provider.request(requestWithError).data)
      } catch let APIProvider.Error.requestFailure(statusCode, errorResponse, _) {
        print("Request failed with statuscode: \(statusCode) and the following errors:")
        errorResponse?.errors?.forEach { error in
          print("Error code: \(error.code)")
          print("Error title: \(error.title)")
          print("Error detail: \(error.detail)")
        }
      } catch {
        print("Something went wrong fetching the apps: \(error.localizedDescription)")
      }
    }
  }

  @MainActor
  private func updateApps(to apps: [AppStoreConnect_Swift_SDK.App]) {
    self.apps = apps
  }
}
