// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "app",
    products: [
        .executable(name: "app", targets: ["Application"])
    ],
    dependencies: [
        .package(url: "https://github.com/purpln/loop.git", branch: "main"),
        .package(url: "https://github.com/purpln/libusb.git", branch: "main")
    ],
    targets: [
        .executableTarget(name: "Application", dependencies: [
            .target(name: "Architecture"),
            .target(name: "USB")
        ]),
        .target(name: "Architecture", dependencies: [
            .product(name: "Loop", package: "loop"),
        ]),
        .target(name: "USB", dependencies: [
            .product(name: "clibusb", package: "libusb")
        ], linkerSettings: [
            .linkedLibrary("usb-1.0", .when(platforms: [.linux]))
        ])
    ], cxxLanguageStandard: .cxx17
)

#if os(macOS)
package.platforms = [.macOS(.v13)]
#endif
