import PackageDescription

let package = Package(
    name: "Phobos",
    dependencies: [
        .Package(url: "https://github.com/younata/CFirmata.git", majorVersion: 0)
    ],
    testDependencies: [
        .Package(url: "https://github.com/briancroom/Quick.git", majorVersion: 0)
    ]
)
