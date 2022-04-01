// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CRDT",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "CRDTKit", targets: ["CRDTKit"]),
        .library(name: "CRDTUI", targets: ["CRDTUI"]),
        .library(name: "Multipeer", targets: ["Multipeer"]),
    ],
    dependencies: [
    ],
    targets: [

        .target(name: "CRDTKit"),

        .target(
            name: "CRDTUI",
            dependencies: [
                "CRDTKit",
            ]),
        
        .target(name: "Multipeer"),
    ]
)
