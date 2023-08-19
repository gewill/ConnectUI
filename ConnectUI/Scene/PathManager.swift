//
//  PathManager.swift
//  ConnectUI
//
//  Created by will on 09/08/2023.
//

import SwiftUI

class PathManager: ObservableObject {
  @Published var path = NavigationPath()

  enum Target: Hashable {
    func hash(into hasher: inout Hasher) {
      switch self {
      case .openSource(let model):
        hasher.combine(model)
      default:
        break
      }
    }

    case reportView, settingsView, connectKeyView, languageView, cacheView, openSource(OpenSourceModel?)
  }
}
