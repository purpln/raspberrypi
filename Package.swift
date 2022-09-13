// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "app",
    products: [.executable(name: "app", targets: ["Application"])],
    dependencies: [.package(url: "https://github.com/purpln/libusb.git", branch: "main")],
    targets: [
        .executableTarget(name: "Application", dependencies: [
            .target(name: "Architecture"),
            .product(name: "clibusb", package: "libusb")
        ], swiftSettings: [
            .unsafeFlags(["-Xfrontend", "-experimental-hermetic-seal-at-link"])
        ], linkerSettings: [
            .linkedLibrary("usb-1.0", .when(platforms: [.linux]))
        ]),
        .target(name: "Architecture")
    ], cxxLanguageStandard: .cxx17
)
