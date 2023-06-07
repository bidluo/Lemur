import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: .init(
        [
            .remote(url: "https://github.com/hmlongco/Factory", requirement: .revision("061b3afe0358a0da7ce568f8272c847910be3dd7"))
        ],
        baseSettings: .settings(
            base: ["IPHONEOS_DEPLOYMENT_TARGET": "15.0"],
            configurations: [
                .debug(name: "Debug"),
            ]
        )
    ),
    platforms: [.iOS]
)

