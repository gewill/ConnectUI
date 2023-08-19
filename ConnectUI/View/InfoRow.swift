//
//  InfoRow.swift
//  ConnectUI
//
//  Created by will on 2023/2/15.
//

import AlertToast
import SwiftUI

struct InfoRow: View {
  @State private var showToast = false

  var title: String
  var info: String?

  // MARK: - life cycle

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(.headline)
      Text(info ?? "--")
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      if let info {
        setPaste(string: info)
        showToast.toggle()
      }
    }
    .toast(isPresenting: $showToast) {
      AlertToast(displayMode: .banner(.pop), type: .regular, title: title + " Copyed")
    }
  }
}

struct InfoRow_Previews: PreviewProvider {
  static var previews: some View {
    InfoRow(title: "Name", info: "Li")
  }
}
