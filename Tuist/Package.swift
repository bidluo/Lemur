// swift-tools-version: 5.9

import PackageDescription

#if TUIST
import ProjectDescription


let packageSettings = PackageSettings(
    baseSettings: .settings(
        base: ["IPHONEOS_DEPLOYMENT_TARGET": "17.0"],
        configurations: [
            .debug(name: "Debug"),
        ]
    )
)
#endif

let package = Package(
    name: "Packages",
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", revision: "061b3afe0358a0da7ce568f8272c847910be3dd7"),
//        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: .init("2.3.0")!)
    ]
)

