import Foundation
import RealmSwift

class BaseModel: Object, ObjectKeyIdentifiable {
  enum Property: String {
    case baseUuid, baseCreateAt, baseUpdatedAt, isArchived
  }

  @Persisted(primaryKey: true) var baseUuid: UUID
  @Persisted var baseCreateAt: Date = .init()
  @Persisted var baseUpdatedAt: Date = .init()
  @Persisted var isArchived: Bool = false

  // MARK: - CRUD methods

  /// 更新属性：updatedAt
  ///
  /// - Parameter date: updatedAt 的新值
  func updateUpdateAt(_ date: Date = Date()) {
    guard let realm = realm else { return }
    realm.writeAsync {
      self.baseUpdatedAt = date
    }
  }

  /// 从数据库中删除
  func delete() {
    guard let realm = realm else { return }
    realm.writeAsync {
      realm.delete(self)
    }
  }

  /// 存档
  func archive(isArchived: Bool = true) {
    guard let realm = realm else { return }
    realm.writeAsync {
      self.isArchived = isArchived
    }
  }
}
