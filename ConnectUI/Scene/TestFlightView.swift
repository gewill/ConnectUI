//
//  TestFlightView.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import AlertToast
import SwiftUI

struct TestFlightView: View {
  @ObservedObject var viewModel = TestFlightViewModel()

  // MARK: - life cycle

  var body: some View {
    NavigationView {
      ZStack {
        List {
          Section("Create a Beta Tester") {
            HStack {
              TextField("email", text: $viewModel.email)
              Text("Missing BetaGroup or Builds")
              Button {
                viewModel.addTester()
              } label: {
                Image(systemName: "plus.circle")
              }
              .font(.title)
            }
          }
          Section("Send an Invitation to a Beta Tester") {
            HStack {
              VStack {
                TextField("appId", text: $viewModel.appId)
                TextField("userId", text: $viewModel.userId)
              }
              Button {
                viewModel.betaTesterInvitations()
              } label: {
                Image(systemName: "plus.circle")
              }
              .font(.title)
            }
          }
          ForEach(viewModel.testers) { tester in
            VStack(alignment: .leading) {
              InfoRow(title: "ID", info: tester.id)
              if let attributes = tester.attributes {
                InfoRow(title: "Email", info: attributes.email)
                InfoRow(title: "firstName", info: attributes.firstName)
                InfoRow(title: "lastName", info: attributes.lastName)
                InfoRow(title: "inviteType", info: attributes.inviteType?.rawValue)
              }
            }
          }
          .onDelete(perform: { indexSet in
            indexSet.reversed().forEach { offset in
              viewModel.deleteTester(id: viewModel.testers[offset].id)
            }
          })
        }
        .refreshable {
          viewModel.loadApps()
        }
        ProgressView()
          .opacity(viewModel.testers.isEmpty ? 1.0 : 0.0)
      }
      .navigationTitle("TestFlight")
    }
    .onAppear {
      viewModel.loadApps()
    }
    .toast(isPresenting: $viewModel.showToast, duration: 10, tapToDismiss: true, alert: {
      AlertToast(displayMode: .alert, type: .error(Color.pink), title: viewModel.errorMessage)
    })
  }
}

struct TestFlightView_Previews: PreviewProvider {
  static var previews: some View {
    TestFlightView()
  }
}
