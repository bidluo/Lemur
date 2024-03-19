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
        Target.target(
            name: "Common",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.ringtale.LemurCommon",
            deploymentTargets: .iOS("17.0"),
            sources: "Sources/Common/**",
            resources: "Resources/**",
            dependencies: dependencies
        )
    ]
)

