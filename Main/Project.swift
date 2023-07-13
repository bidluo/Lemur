import ProjectDescription

let targetName = "Lemur"

// MARK: Configurations
let debugConfiguration: Configuration = .debug(
    name: "Debug",
    xcconfig: .relativeToManifest("Configs/debug.xcconfig")
)

let configurations = [
    debugConfiguration
]

// MARK: Schemes
let debugScheme = Scheme(
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
    .project(target: "Common", path: "../Common"),
    .project(target: "Community", path: "../Community"),
    .project(target: "Post", path: "../Post")
]

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "$(APP_VERSION)",
    "CFBundleVersion": "$(BUILD_NUMBER)",
    "CFBundleDisplayName": "$(APP_DISPLAY_NAME)",
    "ITSAppUsesNonExemptEncryption": false,
    "UILaunchScreen": [:]
]

let mainTarget = Target(
    name: targetName,
    platform: .iOS,
    product: .app,
    bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
    deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone, .ipad]),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: dependencies
)

let project = Project(
    name: targetName,
    organizationName: "liaw.me",
    settings: Settings.settings(configurations: configurations),
    targets: [mainTarget],
    schemes: [
        debugScheme
    ]
)

