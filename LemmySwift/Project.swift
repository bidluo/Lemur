import ProjectDescription

let project = Project(
    name: "LemmySwift",
    settings: Settings.settings(configurations: [
        .debug(name: "Debug")
    ]),
    targets: [
        Target.target(
            name: "LemmySwift",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.ringtale.LemmySwift",
            deploymentTargets: .iOS("17.0"),
            sources: "Sources/LemmySwift/**"
        )
    ]
)

