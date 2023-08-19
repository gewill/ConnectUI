//
//  OpenSourceDetailView.swift
//  iperfman
//
//  Created by will on 14/08/2023.
//

import SwiftUI

struct OpenSourceDetailView: View {
  @Environment(\.openURL) var openURL
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  let model: OpenSourceModel

  // MARK: - life cycle

  var body: some View {
    VStack(spacing: Constant.padding) {
      list
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text(model.name).font(.title)
      }
    }
  }

  var list: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Group {
          Text("Version") + Text(": ") + Text(model.version.replaceEmpty())
          Text("Type") + Text(": ") + Text(model.type)
        }
        Divider()
        Text(model.text)
      }
      .padding()
    }
  }
}

struct OpenSourceDetailView_Previews: PreviewProvider {
  static var previews: some View {
    OpenSourceDetailView(model: OpenSourceModel(name: "Name", text: "abcd", type: "MIT", version: "v1.0"))
  }
}
