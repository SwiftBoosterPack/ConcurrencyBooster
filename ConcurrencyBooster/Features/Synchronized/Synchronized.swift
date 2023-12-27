//
//  Synchronized.swift
//
//
//  Created by Michael Welsh on 2023-12-26.
//

import Foundation

/// @Synchronized guarantees thread-safety for concurrent accesses to a property.
/// For class types, you should _not_ mutate a property that is guarded by synchronized directly - instead use the `.synchronized { }` function.
/// Structs may be modified directly.
///
/// Good examples:
///    - `myDict[25_01_2021] = "Blobiverse"`
///    - `$classType.synchronized { $0.perform("string") }`
///
/// Bad examples:
///   - `classType.perform("string")`   Should NOT attempt to mutate non-atomically.
///
/// Structs won't let you do it anyway, but classes will—and may behave unexpectedly.
///
@propertyWrapper
public final class Synchronized<Value> {
  // MARK: Lifecycle

  public init(wrappedValue value: Value) {
    self.value = value
  }

  // MARK: Public

  public var wrappedValue: Value {
    get {
      lock.synchronized { value }
    }
    _modify {
      lock.lock(); defer { lock.unlock() }
      yield &value
    }
  }

  public var projectedValue: Synchronized<Value> { self }

  @discardableResult
  public func synchronized<T>(_ closure: (inout Value) throws -> T) rethrows -> T {
    try lock.synchronized {
      try closure(&value)
    }
  }

  // MARK: Private

  private let lock = NSRecursiveLock()
  private var value: Value
}
