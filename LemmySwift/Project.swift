import ProjectDescription

let project = Project(
    name: "LemmySwift",
    settings: Settings.settings(configurations: [
        .debug(name: "Debug")
    ]),
    targets: [
        Target(
            name: "LemmySwift",
            platform: .iOS,
            product: .framework,
            bundleId: "me.liaw.LemmySwift",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone, .ipad]),
            sources: "Sources/LemmySwift/**"
        )
    ]
)

