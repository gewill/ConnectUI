import SwiftUI

struct OpenSourceScene: View {
  @Environment(\.openURL) var openURL
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  // MARK: - life cycle

  var body: some View {
    VStack(spacing: Constant.padding) {
      list
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("Open Source").font(.title)
      }
    }
  }

  var list: some View {
    ScrollView {
      VStack {
        VStack(alignment: .leading) {
          ForEach(allOpenSourceModels, id: \.name) { model in
            NavigationLink(value: PathManager.Target.openSource(model)) {
              HStack(alignment: .center, spacing: Constant.padding) {
                Text(model.name)
                Spacer()
                Image(systemName: "chevron.right")
              }
              .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(Constant.cornerRadius)
            .shadow(radius: 3)
          }
        }
      }
      .padding()
    }
  }
}

struct OpenSourceScene_Previews: PreviewProvider {
  static var previews: some View {
    OpenSourceScene()
  }
}
