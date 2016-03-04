import PackageDescription

let package = Package(
    name: "Phobos",
    testDependencies: [
        .Package(url: "https://github.com/briancroom/Quick.git", majorVersion: 0)
    ]
)
