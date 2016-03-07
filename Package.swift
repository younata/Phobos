import PackageDescription

let package = Package(
    name: "Phobos",
    dependencies: [
        .Package(url: "https://github.com/younata/CFirmata.git", majorVersion: 0),
        .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0),
        .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 1),
        .Package(url: "https://github.com/bignerdranch/Freddy.git", majorVersion: 2),
    ],
    testDependencies: [
        .Package(url: "https://github.com/briancroom/Quick.git", majorVersion: 0)
    ]
)
