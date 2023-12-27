// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "ConcurrencyBooster",
  platforms: [
    .iOS(.v16), .macOS(.v12), .macCatalyst(.v13),
  ],
  products: [
    .library(
      name: "ConcurrencyBooster",
      targets: ["ConcurrencyBooster"]
    ),
  ],
  targets: [
    .target(
      name: "ConcurrencyBooster",
      path: "ConcurrencyBooster",
      exclude: [],
      swiftSettings: [
        .unsafeFlags(["-enforce-exclusivity=unchecked"]),
      ]
    ),
    .testTarget(
      name: "ConcurrencyBoosterTests",
      dependencies: ["ConcurrencyBooster"],
      path: "ConcurrencyBoosterTests"
    ),
  ]
)

