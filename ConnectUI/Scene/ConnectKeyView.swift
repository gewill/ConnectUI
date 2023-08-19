//
//  ConnectKeyView.swift
//  ConnectUI
//
//  Created by will on 05/08/2023.
//

import SwiftUI

struct ConnectKeyView: View {
  @EnvironmentObject var store: Store
  @ObservedObject var viewModel = ConnectKeyViewModel()

  // MARK: - life cycle

  var body: some View {
    List {
      Section {
        VStack(alignment: .leading) {
          Text("Issuer ID").bold()
          TextField("Issuer ID", text: $store.connectKeyModel.issuerID)
        }
        VStack(alignment: .leading) {
          Text("Vendor Number").bold()
          TextField("Vendor Number", text: $store.connectKeyModel.vendorNumber)
        }

        VStack(alignment: .leading) {
          Text("Private Key ID").bold()
          TextField("Private Key ID", text: $store.connectKeyModel.privateKeyID)
        }
        VStack(alignment: .leading) {
          Text("Private Key").bold()
          TextField("Private Key", text: $store.connectKeyModel.privateKey, axis: .vertical)
            .lineLimit(5)
        }
      }
      Section("Verify") {
        Button {
          viewModel.loadApps()
        } label: {
          HStack(spacing: 15.0) {
            Image(systemName: "network")
            Text("API test")
          }
        }
        testStateView
      }

      helpView
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("Connect API Key").font(.title)
      }
    }
  }

  var testStateView: some View {
    VStack {
      if case .testing = viewModel.testState {
        HStack(spacing: 15.0) {
          ProgressView()
            .progressViewStyle(.circular)
          Text("Testing...")
        }
      } else if case .success = viewModel.testState {
        HStack(spacing: 15.0) {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(Color.green)
          Text("Success")
        }
      } else if case let .error(message) = viewModel.testState {
        HStack(alignment: .top, spacing: 15.0) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(Color.pink)
          Text(message)
        }
      }
    }
  }

  var helpView: some View {
    Section("Help") {
      Text("Generate-Key")
      Text("Get-Vendor-Number")
    }
  }
}

struct ConnectKeyView_Previews: PreviewProvider {
  static var previews: some View {
    ConnectKeyView()
      .environmentObject(store)
  }
}
