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
    .project(target: "Common", path: "../Common"),
    .project(target: "Community", path: "../Community"),
    .project(target: "Post", path: "../Post"),
    .project(target: "Setting", path: "../Setting")
]

let infoPlist: InfoPlist = .extendingDefault(with: [
    "CFBundleShortVersionString": "$(APP_VERSION)",
    "CFBundleVersion": "$(BUILD_NUMBER)",
    "CFBundleDisplayName": "$(APP_DISPLAY_NAME)",
    "ITSAppUsesNonExemptEncryption": false,
    "UILaunchScreen": [:]
])

let mainTarget = Target.target(
    name: targetName,
    destinations: .iOS,
    product: .app,
    bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
    deploymentTargets: .iOS("17.0"),
    infoPlist: infoPlist,
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: dependencies
)

let project = Project(
    name: targetName,
    organizationName: "ringtale.io",
    settings: .settings(base: [
        "CODE_SIGN_STYLE": "Manual",
        "PROVISIONING_PROFILE_SPECIFIER": "$(PROVISIONING_PROFILE_SPECIFIER)",
        "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)",
//        "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)",
        "OTHER_CODE_SIGN_FLAGS": "$(inherited) --keychain=$(SRCROOT)/../Derived/signing.keychain"

    ], configurations: configurations, defaultSettings: .recommended),
    targets: [mainTarget],
    schemes: [
        debugScheme
    ]
)

