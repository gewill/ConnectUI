//
//  MainView.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import SwiftUI

struct MainView: View {
  @StateObject var pathManager = PathManager()

  var body: some View {
//    TabView {
//      AppsListView()
//        .tabItem {
//          Label("Apps", image: "appstore-svgrepo-com")
//        }
//      ReportView()
//        .tabItem {
//          Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
//        }
//      TestFlightView()
//        .tabItem {
//          Label("TestFlight", image: "testflight-svgrepo-com")
//        }
//    }
    NavigationStack(path: $pathManager.path) {
      ReportView()
        .navigationDestination(for: PathManager.Target.self) { target in
          switch target {
          case .reportView:
            ReportView()
          case .settingsView:
            SettingsView()
          case .connectKeyView:
            ConnectKeyView()
          case .cacheView:
            CacheView()
          case .languageView:
            ChangeLanguageScene()
          case .openSource(let model):
            if let model {
              OpenSourceDetailView(model: model)
            } else {
              OpenSourceScene()
            }
          @unknown default:
            VStack {
              Text("Content not found.")
            }
            .navigationTitle("404")
          }
        }
    }
    .environmentObject(pathManager)
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
