# ConcurrencyBooster

Concurrency tools for Swift.

Adds functionality to allow for better support of concurrency within Swift.

Explicitly has `SWIFT_ENFORCE_EXCLUSIVE_ACCESS = off;` (`-enforce-exclusivity=unchecked`) to allow more fine-grained control of the concurrent environment.

Any code added to this module _MUST_ be extremely thoroughly tested with unit tests and validated for concurrency safety.

## Extensions
- `synchronized` for accessing contents with locks, allowing for linear code flow as opposed to needing to maintain locking states.

## Features
- `@Synchronized` property annotation, to allow safe access to properties. Simimlar to Objective-C `atomic` properties.
