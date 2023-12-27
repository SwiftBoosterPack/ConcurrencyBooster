//
//  NSRecursiveLock+Synchronized.swift
//
//
//  Created by Michael Welsh on 2023-12-26.
//

import Foundation

/// Extensions which enable usage of `synchronized`. See method documentation for details.
public extension NSRecursiveLock {

  /// Extension which allows callers to write linear code within a lock and have it automatically be released.
  ///
  /// Before:
  /// ```swift
  /// let lock = NSRecursiveLock()
  /// let capturedValue: String
  /// lock.lock()
  /// executeSomeWork()
  /// capturedValue = doSomeMoreWork()
  /// lock.unlock()
  /// ```
  ///
  /// After:
  /// ```swift
  /// let lock = NSRecursiveLock()
  /// let capturedValue = lock.synchronized {
  ///    executeSomeWork()
  ///    return doSomeMoreWork()
  /// }
  /// ```
  @discardableResult
  func synchronized<T>(_ closure: () throws -> T) rethrows -> T {
    lock()
    defer { unlock() }
    return try closure()
  }
}
