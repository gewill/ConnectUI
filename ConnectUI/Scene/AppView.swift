//
//  AppView.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import SwiftUI

struct AppView: View {
  var viewModel: AppViewModel

  init(appId: String) {
    self.viewModel = AppViewModel(appId: appId)
  }

  var body: some View {
    NavigationView {
      List {
        Section {
          InfoRow(title: "ID", info: viewModel.appId)
          Link(destination: URL(string: "https://apps.apple.com/app/id\(viewModel.appId)")!) {
            Text("在 App Store 中查看")
          }
        }
        if let attributes = viewModel.app?.attributes {
          Section("attributes") {
            InfoRow(title: "Name", info: attributes.name)
            InfoRow(title: "bundleID", info: attributes.bundleID)
            InfoRow(title: "sku", info: attributes.sku)
            InfoRow(title: "primaryLocale", info: attributes.primaryLocale)
          }
        }
      }
    }
    .refreshable {
      viewModel.loadApps()
    }
    .onAppear {
      viewModel.loadApps()
    }
    .navigationTitle(viewModel.app?.attributes?.name ?? "")
  }
}

struct AppInfoView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(appId: "")
  }
}
