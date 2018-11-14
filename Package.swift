// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "otpio",
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "../libfa", from: "1.1.0"),
        .package(url: "../libtoken", from: "1.0.1")
    ],
    targets: [
        .target(name: "otpio", dependencies: ["libfa", "libtoken"]),
    ]
)
