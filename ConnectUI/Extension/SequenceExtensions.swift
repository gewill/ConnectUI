//
//  SequenceExtensions.swift
//  ConnectUI
//
//  Created by will on 05/08/2023.
//

import Foundation

public extension Sequence {
  func asyncReduce<Result>(
    _ initialResult: Result,
    _ nextPartialResult: (Result, Element) async throws -> Result
  ) async rethrows -> Result {
    var result = initialResult
    for element in self {
      result = try await nextPartialResult(result, element)
    }
    return result
  }
}
