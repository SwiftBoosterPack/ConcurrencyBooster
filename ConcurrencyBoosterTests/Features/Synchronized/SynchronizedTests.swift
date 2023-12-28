//
//  SynchronizedTests.swift
//
//
//  Created by Michael Welsh on 2023-12-26.
//

import Foundation
import ConcurrencyBooster
import XCTest

class SynchronizedTests: XCTestCase {
  @Synchronized var sut = [String]()
  @Synchronized var sut_dict = [Int: String]()
  @Synchronized var sut_bool = false
  @Synchronized var sut_set = Set<String>()

  func test_renentrant_success() {
    // Arrange
    let first = "ONE"
    let second = "TWO"
    var capturedContent: [String] = []

    // Act
    // Measure runs 10 times by default.
    measure {
      $sut.synchronized { array in
        array.append(first)
        $sut.synchronized { innerArray in
          innerArray.append(second)
          capturedContent = innerArray
        }
      }
    }

    // Assert
    XCTAssertEqual(
      capturedContent,
      [
        "ONE",
        "TWO",
        "ONE",
        "TWO",
        "ONE",
        "TWO",
        "ONE",
        "TWO",
        "ONE",
        "TWO",
        "ONE",
        "TWO",
        "ONE",
        "TWO",
        "ONE",
        "TWO",
        "ONE",
        "TWO",
        "ONE",
        "TWO",
      ]
    )
  }

  func test_concurrencyResilience() {
    let queue = DispatchQueue.global()

    let dispatchGroup = DispatchGroup()

    // Act
    for val in 0..<50_000 {
      dispatchGroup.enter()
      // Append content asynchronously.
      queue.async {

        self.$sut.synchronized { array in
          array.append(String(describing: val))
        }
        dispatchGroup.leave()
      }
    }

    // We use a dispatch group to keep `subject` in reference, otherwise the async above can be flaky.
    dispatchGroup.wait()

    // Assert
    $sut.synchronized { array in
      XCTAssertEqual(array.count, 50_000)
    }
  }

  func test_wrappedValueRead_projectedValueConcurrentRead() {
    DispatchQueue.concurrentPerform(iterations: 1_000) { i in
      _ = $sut.wrappedValue
      _ = sut
      $sut.synchronized { $0.append("\(i)") }
    }

    XCTAssertEqual(sut.count, 1_000)
  }

  func test_wrappedValueModify_concurrentArrayAppend() {
    DispatchQueue.concurrentPerform(iterations: 100) { i in
      for _ in 0..<100 {
        sut.append("\(i)")
        sut += ["\(i)"]
        $sut.synchronized { $0.append("\(i)") }
      }
    }
    XCTAssertEqual(sut.count, 30_000)
  }

  func test_wrappedValueModify_concurrentDictionaryRemove() {
    DispatchQueue.concurrentPerform(iterations: 10_000) { i in
      sut_dict[i] = "\(i)"
    }
    DispatchQueue.concurrentPerform(iterations: 10_000) { i in
      sut_dict.removeValue(forKey: i)
    }
    XCTAssertEqual(sut_dict.count, 0)
  }

  func test_wrappedValue_concurrentBooleanAssignAndRead() {
    DispatchQueue.concurrentPerform(iterations: 10_000) { i in
      // Assign
      sut_bool = i % 2 == 0
      // Read
      _ = sut_bool
    }
    sut_bool = true
    XCTAssertTrue(sut_bool)
  }

  func test_wrappedValueModify_concurrentSetRemove() {
    DispatchQueue.concurrentPerform(iterations: 10_000) { i in
      sut_set.insert("\(i)")
    }
    DispatchQueue.concurrentPerform(iterations: 10_000) { i in
      _ = sut_set.contains("\(i)")
      sut_set.remove("\(i)")
    }
    XCTAssertEqual(sut_set.count, 0)
  }
}
