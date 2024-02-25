//
//  TestFlightViewModel.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import AppStoreConnect_Swift_SDK
import Foundation
import SwiftUI

final class TestFlightViewModel: ObservableObject {
  @Published var testers: [AppStoreConnect_Swift_SDK.BetaTester] = []
  @Published var email: String = ""
  @Published var userId: String = ""
  @Published var appId: String = ""

  @Published var errorMessage: String = ""
  @Published var showToast = false

  func loadApps() {
    guard let provider = provider else { return }
    Task.detached {
      let request = APIEndpoint
        .v1
        .betaTesters
        .get()

      do {
        let testers = try await provider.request(request).data
        await self.updateTesters(to: testers)
      } catch {
        print("Something went wrong fetching the apps: \(error.localizedDescription)")
      }
    }
  }

  func deleteTester(id: String) {
    guard let provider = provider else { return }
    Task.detached {
      let request = APIEndpoint
        .v1
        .betaTesters
        .id(id)
        .delete

      do {
        try await provider.request(request)
      } catch {
        await self.showError(message: "Delete Tester error: \(error.localizedDescription)")
      }
    }
  }

  func addTester() {
    guard let provider = provider else { return }
    Task.detached {
      let request = APIEndpoint
        .v1
        .betaTesters
        .post(BetaTesterCreateRequest(data: BetaTesterCreateRequest.Data(type: .betaTesters, attributes: BetaTesterCreateRequest.Data.Attributes(email: self.email))))

      do {
        let rep = try await provider.request(request)
        print(rep)
      } catch {
        await self.showError(message: "Add Tester error: \(error.localizedDescription)")
      }
    }
  }

  func betaTesterInvitations() {
    guard let provider = provider else { return }
    Task.detached {
      let request = APIEndpoint
        .v1
        .betaTesterInvitations
        .post(BetaTesterInvitationCreateRequest(data: BetaTesterInvitationCreateRequest.Data(type: .betaTesterInvitations, relationships: BetaTesterInvitationCreateRequest.Data.Relationships(betaTester: BetaTesterInvitationCreateRequest.Data.Relationships.BetaTester(data: BetaTesterInvitationCreateRequest.Data.Relationships.BetaTester.Data(type: .betaTesters, id: self.userId)), app: BetaTesterInvitationCreateRequest.Data.Relationships.App(data: BetaTesterInvitationCreateRequest.Data.Relationships.App.Data(type: .apps, id: self.appId))))))

      do {
        let rep = try await provider.request(request)
        print(rep)
      } catch {
        await self.showError(message: "betaTesterInvitations error: \(error.localizedDescription)")
      }
    }
  }

  func removeBetaTesterAccessToApps(id: String) {
    guard let provider = provider else { return }
    Task.detached {
      let request = APIEndpoint
        .v1
        .betaTesters
        .id(id)
        .relationships
        .apps
        .delete(BetaTesterAppsLinkagesRequest(data: []))

      do {
        try await provider.request(request)
      } catch {
        await self.showError(message: "Remove a Beta Tester’s Access to Apps error: \(error.localizedDescription)")
      }
    }
  }

  @MainActor
  private func updateTesters(to testers: [AppStoreConnect_Swift_SDK.BetaTester]) {
    self.testers = testers
  }

  @MainActor
  private func showError(message: String) {
    self.errorMessage = message
    self.showToast = true
    print(self.errorMessage)
  }
}
