import FileKit
import Foundation
import RealmSwift

let realmQueue = DispatchQueue(label: "org.gewill.ConnectUI.realm",
                               qos: .background,
                               attributes: [.concurrent])

struct RealmProvider {
  let configuration: Realm.Configuration

  internal init(config: Realm.Configuration) {
    configuration = config
  }

  var realm: Realm {
    return try! Realm(configuration: configuration)
  }

  // MARK: - subscription

  private static let mainConfig = Realm.Configuration(
    fileURL: (Path.userDocuments + "ConnectUI.realm").url,
    schemaVersion: 1,
    migrationBlock: migrationBlock,
    deleteRealmIfMigrationNeeded: true,
    objectTypes: [SaleModel.self, CurrencyModel.self]
  )

  static var main: RealmProvider = .init(config: mainConfig)

  static let migrationBlock: MigrationBlock = { _, oldSchemaVersion in
    if oldSchemaVersion < 4 {
      // if just the name of your model's property changed you can do this
//            migration.renameProperty(onType: SubscriptionModel.className(),
//                                     from: SubscriptionModel.Property.startDate.rawValue,
//                                     to: SubscriptionModel.Property.endDate.rawValue)

      // if you want to fill a new property with some values you have to enumerate
      // the existing objects and set the new value
//      migration.enumerateObjects(ofType: ConfigModel.className()) { _, newObject in
//        // 新添加的属性默认值要处理
//        newObject?["omit"] = "0"
//      }

      // New properties can be migrated automatically, but must update the schema version.
      // 新属性可以自动迁移，但必须更新Schema版本。
    }
  }
}
