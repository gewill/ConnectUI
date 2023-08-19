//
//  CacheView.swift
//  ConnectUI
//
//  Created by will on 09/08/2023.
//

import RealmSwift
import SwiftUI

struct CacheView: View {
  @Environment(\.realm) var realm: Realm
  @State var isLoadingPage: Bool = false
  @AppStorage(UserDefaultsKeys.requestDataIgnoreCaches.rawValue) var requestDataIgnoreCaches: Bool = false
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("All sales reports save in database by default.")
          .font(.title3)
          .padding()
        VStack {
          Group {
            Button {
              isLoadingPage = true
              let saleModels = realm.objects(SaleModel.self).where {
                $0.connectKeyId == store.connectKeyModel.id
              }
              realm.writeAsync {
                realm.delete(saleModels)
              } onComplete: { _ in
                isLoadingPage = false
              }
            } label: {
              HStack {
                if isLoadingPage {
                  ProgressView().progressViewStyle(.circular)
                    .padding(.trailing)
                } else {
                  Image(systemName: "xmark.circle")
                    .foregroundColor(.pink)
                }
                Text("Clear all caches")
                  .foregroundColor(.pink)
                Spacer()
              }
              .contentShape(Rectangle())
            }

            Toggle("Request data, ignore caches in database", isOn: $requestDataIgnoreCaches)
              .toggleStyle(.automatic)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .buttonStyle(.plain)
          .padding()
          .background(.ultraThinMaterial)
          .cornerRadius(Constant.cornerRadius)
          .shadow(radius: 3)
        }
      }
      .padding()
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("Caches").font(.title)
      }
    }
  }
}

struct CacheView_Previews: PreviewProvider {
  static var previews: some View {
    CacheView()
  }
}
