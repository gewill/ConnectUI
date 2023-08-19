//
//  AppsListView.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import AppStoreConnect_Swift_SDK
import SwiftUI

struct AppsListView: View {
  @ObservedObject var viewModel = AppsListViewModel()

  var body: some View {
    NavigationView {
      ZStack {
        ScrollView {
          VStack {
            ForEach(viewModel.apps) { app in
              NavigationLink {
                AppView(appId: app.id)
              } label: {
                VStack(alignment: .leading) {
                  Text(app.attributes?.name ?? "Unknown name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                  Text(app.attributes?.sku ?? "Unknown sku")
                    .font(.subheadline)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(Constant.cornerRadius)
                .shadow(radius: 3)
              }
            }
            .padding()
          }
          .padding()
        }
        .refreshable {
          viewModel.loadApps()
        }
        ProgressView()
          .opacity(viewModel.apps.isEmpty ? 1.0 : 0.0)
      }
      .navigationTitle("List of Apps")
    }
    .onAppear {
      viewModel.loadApps()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppsListView()
  }
}
