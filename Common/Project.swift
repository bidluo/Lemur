import ProjectDescription

var dependencies: [TargetDependency] = [
    .project(target: "LemmySwift", path: "../LemmySwift"),
    .external(name: "Factory")
]

let project = Project(
    name: "Common",
    settings: Settings.settings(configurations: [
        .debug(name: "Debug")
    ]),
    targets: [
        Target(
            name: "Common",
            platform: .iOS,
            product: .framework,
            bundleId: "me.liaw.LemurCommon",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone, .ipad]),
            sources: "Sources/Common/**",
            resources: "Resources/**",
            dependencies: dependencies
        )
    ]
)

