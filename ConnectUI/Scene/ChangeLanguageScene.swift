import SwiftUI

struct ChangeLanguageScene: View {
  @AppStorage(UserDefaultsKeys.selectedLocale.rawValue) var selectedLocale: LocaleConstants = .system

  var body: some View {
    VStack(alignment: .leading) {
      list
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("Language").font(.title)
      }
    }
  }

  var list: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Picker("Language", selection: $selectedLocale) {
          ForEach(LocaleConstants.allCases) {
            Text($0.title)
          }
        }
        .pickerStyle(InlinePickerStyle())
      }
      .padding()
    }
  }
}

struct ChangeLanguageScene_Previews: PreviewProvider {
  static var previews: some View {
    ChangeLanguageScene()
  }
}
