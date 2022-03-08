// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "app",
    products: [.executable(name: "app", targets: ["app"])],
    dependencies: [.package(url: "https://github.com/purpln/libusb.git", .branch("main"))],
    targets: [.target(name: "app", dependencies: [.product(name: "clibusb", package: "libusb")], linkerSettings: [.linkedLibrary("usb-1.0", .when(platforms: [.linux]))])]
)
