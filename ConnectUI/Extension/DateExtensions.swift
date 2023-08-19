import Foundation

extension Date {
  /// SwifterSwift: User’s current calendar.
  var calendar: Calendar { Calendar.current }

  /// SwifterSwift: Date string from date.
  ///
  ///     Date().string(withFormat: "dd/MM/yyyy") -> "1/12/17"
  ///     Date().string(withFormat: "HH:mm") -> "23:50"
  ///     Date().string(withFormat: "dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
  ///
  /// - Parameter format: Date format (default is "yyyy-MM-dd HH:mm:ss").
  /// - Returns: date string.
  func string(withFormat format: String = "yyyy-MM-dd") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }

  /// SwifterSwift: get number of days between two date
  ///
  /// - Parameter date: date to compare self to.
  /// - Returns: number of days between self and given date.
  func daysSince(_ date: Date) -> Double {
    return timeIntervalSince(date) / (3600 * 24)
  }

  /// SwifterSwift: Day.
  ///
  ///   Date().day -> 12
  ///
  ///   var someDate = Date()
  ///   someDate.day = 1 // sets someDate's day of month to 1.
  ///
  var day: Int {
    get {
      return calendar.component(.day, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .day, in: .month, for: self)!
      guard allowedRange.contains(newValue) else { return }

      let currentDay = calendar.component(.day, from: self)
      let daysToAdd = newValue - currentDay
      if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
        self = date
      }
    }
  }

  /// SwifterSwift: Yesterday date.
  ///
  ///     let date = Date() // "Oct 3, 2018, 10:57:11"
  ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
  ///
  var yesterday: Date {
    return calendar.date(byAdding: .day, value: -1, to: self) ?? Date()
  }

  /// SwifterSwift: Tomorrow's date.
  ///
  ///     let date = Date() // "Oct 3, 2018, 10:57:11"
  ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
  ///
  var tomorrow: Date {
    return calendar.date(byAdding: .day, value: 1, to: self) ?? Date()
  }

  var previousMonth: Date {
    return calendar.date(byAdding: .month, value: -1, to: self) ?? Date()
  }

  var nextMonth: Date {
    return calendar.date(byAdding: .month, value: 1, to: self) ?? Date()
  }

  var firstDayOfMonth: Date {
    let format = "yyyy-MM"
    return string(withFormat: format).dateTime(withFormat: format) ?? self
  }

  /// SwifterSwift: UNIX timestamp from date.
  ///
  ///    Date().unixTimestamp -> 1484233862.826291
  ///
  var unixTimestamp: Double {
    return timeIntervalSince1970
  }

  static var oneDayInSeconds: TimeInterval = 60 * 60 * 24
}

extension Date: RawRepresentable {
  public typealias RawValue = String
  public init?(rawValue: RawValue) {
    guard let data = rawValue.data(using: .utf8),
          let date = try? JSONDecoder().decode(Date.self, from: data)
    else {
      return nil
    }
    self = date
  }

  public var rawValue: RawValue {
    guard let data = try? JSONEncoder().encode(self),
          let result = String(data: data, encoding: .utf8)
    else {
      return ""
    }
    return result
  }
}
