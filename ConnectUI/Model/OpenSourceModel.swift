import Foundation

struct OpenSourceModel: Codable, Hashable {
  let name: String
  let text: String
  let type: String
  let version: String

  private enum CodingKeys: String, CodingKey {
    case name
    case text
    case type
    case version
  }

  init(name: String, text: String, type: String, version: String) {
    self.name = name
    self.text = text
    self.type = type
    self.version = version
  }
}

let allOpenSourceModels: [OpenSourceModel] = {
  var tmp = [OpenSourceModel]()
  let decoder = JSONDecoder()
  if let url = Bundle.main.url(forResource: "licenses", withExtension: "json"),
     let data = try? Data(contentsOf: url),
     let models = try? decoder.decode([OpenSourceModel].self, from: data)
  {
    tmp.append(contentsOf: models)
  }
  if let url = Bundle.main.url(forResource: "ManualEntryLicenses", withExtension: "json"),
     let data = try? Data(contentsOf: url),
     let models = try? decoder.decode([OpenSourceModel].self, from: data)
  {
    tmp.append(contentsOf: models)
  }
  return tmp
}()
