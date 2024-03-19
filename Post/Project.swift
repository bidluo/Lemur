import ProjectDescription

let targetName = "Post"

// MARK: Configurations
let debugConfiguration: Configuration = .debug(
    name: "Debug",
    xcconfig: .relativeToManifest("Configs/debug.xcconfig")
)

let configurations = [
    debugConfiguration
]

// MARK: Schemes
let debugScheme = Scheme.scheme(
    name: "\(targetName)-Debug",
    shared: true,
    buildAction: .buildAction(targets: [TargetReference(stringLiteral: targetName)]),
    testAction: .testPlans([], configuration: .configuration("Debug")),
    runAction: .runAction(configuration: .configuration("Debug")),
    archiveAction: .archiveAction(configuration: .configuration("Debug")),
    profileAction: .profileAction(configuration: .configuration("Debug")),
    analyzeAction: .analyzeAction(configuration: .configuration("Debug"))
)

// MARK: Dependencies
var dependencies: [TargetDependency] = [
    .project(target: "Common", path: "../Common")
]

let infoPlist: InfoPlist = .extendingDefault(with: [
    "CFBundleShortVersionString": "$(APP_VERSION)",
    "CFBundleVersion": "$(BUILD_NUMBER)",
    "CFBundleDisplayName": "$(APP_DISPLAY_NAME)",
    "ITSAppUsesNonExemptEncryption": false
])

let appTarget = Target.target(
    name: "\(targetName)-App",
    destinations: .iOS,
    product: .app,
    bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
    deploymentTargets: .iOS("17.0"),
    infoPlist: infoPlist,
    sources: ["AppSources/**"],
    dependencies: [.target(name: targetName)]
)

let mainTarget = Target.target(
    name: targetName,
    destinations: .iOS,
    product: .framework,
    bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
    deploymentTargets: .iOS("17.0"),
    sources: "Sources/**",
    resources: ["Resources/**"],
    dependencies: dependencies + [
        .package(product: "MarkdownUI", type: .runtime)
    ]
)

let project = Project(
    name: targetName,
    organizationName: "ringtale.io",
    packages: [
        .remote(url: "https://github.com/gonzalezreal/swift-markdown-ui", requirement: .exact("2.3.0"))
        ],
    settings: Settings.settings(configurations: configurations),
    targets: [mainTarget, appTarget],
    schemes: [
        debugScheme
    ]
)

