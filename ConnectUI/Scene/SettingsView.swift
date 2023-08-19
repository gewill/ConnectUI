//
//  SettingsView.swift
//  ConnectUI
//
//  Created by will on 05/08/2023.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.openURL) var openURL
  let appStoreUrl = "https://apps.apple.com/app/id1672859290"
  let writeReview = "?action=write-review"

  var body: some View {
    ScrollView {
      VStack {
        Group {
          NavigationLink(value: PathManager.Target.connectKeyView) {
            HStack {
              Text("Connect API Key")
              Spacer()
              Image.chevronRight
            }
            .contentShape(Rectangle())
          }

          NavigationLink(value: PathManager.Target.languageView) {
            HStack {
              Text("Language")
              Spacer()
              Image.chevronRight
            }
            .contentShape(Rectangle())
          }

          NavigationLink(value: PathManager.Target.cacheView) {
            HStack {
              Text("Caches")
              Spacer()
              Image.chevronRight
            }
            .contentShape(Rectangle())
          }
        }
        .buttonStyle(.plain)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Constant.cornerRadius)
        .shadow(radius: 3)
      }
      .padding()

      VStack {
        Group {
          HStack(alignment: .center, spacing: Constant.padding) {
            Text("App Version")
            Spacer()
            Text(Bundle.main.appVersionInfo)
          }

          Button(action: {
            openURL(URL(string: appStoreUrl + writeReview)!)
          }, label: {
            HStack {
              Text("Review on App Store")
              Spacer()
              Image.chevronRight
            }
          })

          HStack {
            ShareLink(item: URL(string: appStoreUrl)!) {
              Text("Share App to friends")
            }
            Spacer()
            Image.chevronRight
          }
          
          NavigationLink(value: PathManager.Target.openSource(nil)) {
            HStack {
              Text("Open Source")
              Spacer()
              Image.chevronRight
            }
            .contentShape(Rectangle())
          }
        }
        .buttonStyle(.plain)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Constant.cornerRadius)
        .shadow(radius: 3)
      }
      .padding()
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("Settings").font(.title)
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
