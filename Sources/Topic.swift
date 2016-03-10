public struct Topic: Hashable, CustomStringConvertible {
    public let hostname: String
    public let path: String

    public var hashValue: Int { return hostname.hashValue ^ path.hashValue }

    public var description: String { return hostname + "/" + path }

    public init(hostname: String, path: String) {
        self.hostname = hostname
        self.path = path
    }

    public init(_ path: String) {
        self.init(hostname: "localhost", path: path)
    }
}

public func == (lhs: Topic, rhs: Topic) -> Bool {
    return lhs.hostname == rhs.hostname && lhs.path == rhs.path
}
