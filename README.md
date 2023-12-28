# ConcurrencyBooster

Concurrency tools for Swift.

Adds functionality to allow for better support of concurrency within Swift.

Explicitly has `SWIFT_ENFORCE_EXCLUSIVE_ACCESS = off;` (`-enforce-exclusivity=unchecked`) to allow more fine-grained control of the concurrent environment.

Any code added to this module _MUST_ be extremely thoroughly tested with unit tests and validated for concurrency safety.

## Extensions
### `synchronized` for locks
For accessing contents with locks, allowing for linear code flow as opposed to needing to maintain locking states.
Before:
```swift
let lock = NSRecursiveLock()
let capturedValue: String
lock.lock()
executeSomeWork()
capturedValue = doSomeMoreWork()
lock.unlock()
```
After:
```swift
let lock = NSRecursiveLock()
let capturedValue = lock.synchronized {
   executeSomeWork()
   return doSomeMoreWork()
}
```

## Features
### `@Synchronized` property annotation
Allow safe access to properties. Simimlar to Objective-C `atomic` properties.
```swift
// Simple example of usage.
class MyClass {
  @Synchronized private var arrayContent = [String]()

  func threadSafeAddToArray(_ content: String) {
    $arrayContent.synchronized { array in
      array.append(content)
    }
  }
}
```
