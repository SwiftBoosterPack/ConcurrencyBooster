//
//  NSRecursiveLock+SynchronizedTests.swift
//
//
//  Created by Michael Welsh on 2023-12-26.
//

import Foundation
import XCTest
@testable import ConcurrencyBooster

class NSRecursiveLock_SafelyTests: XCTestCase {
  let sut = NSRecursiveLock()

  func test_reentrant_success() {
    // Arrange
    var nums = [Int]()

    // Act
    // Run the test using measure to execute several times.
    measure {
      DispatchQueue.concurrentPerform(iterations: 100_000) { i in
        // Recurse into the lock, calling synchronized twice.
        sut.synchronized {
          sut.synchronized {
            nums.append(i)
          }
        }
      }
    }

    // Assert
    XCTAssertEqual(nums.count, 1_000_000) // measure runs 10x
  }

  func test_returnValue() {
    // Arrange

    // Act
    let val = sut.synchronized {
      return "JustSomeString"
    }

    // Assert
    XCTAssertEqual(val, "JustSomeString")
  }
}
