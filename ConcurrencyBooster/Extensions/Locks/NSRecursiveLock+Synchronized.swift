//
//  NSRecursiveLock+Synchronized.swift
//
//
//  Created by Michael Welsh on 2023-12-26.
//

import Foundation

public extension NSRecursiveLock {
  @discardableResult
  func synchronized<T>(_ closure: () throws -> T) rethrows -> T {
    lock()
    defer { unlock() }
    return try closure()
  }
}
