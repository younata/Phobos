public enum PhobosError: ErrorType {
    case Network
    case Serialize
    case Deserialize
}

public protocol Serializable {
    init?(bytes: UnsafePointer<UInt8>)

    func serialize() -> [UInt8]
}

/// Time in seconds
public typealias TimeInterval = Double

/**
 Represents a 3d vector, unitless
 */
public struct Vector: Equatable {
    public let x: Double
    public let y: Double
    public let z: Double

    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}

/**
 Combines Linear and Angular vectors
 */
public struct Twist: Equatable {
    public let angular: Vector
    public let linear: Vector

    public init(angular: Vector, linear: Vector) {
        self.angular = angular
        self.linear = linear
    }
}

/**
 Twist + Error
 */
public struct TwistError: Equatable {
    public let twist: Twist
    public let error: Twist

    public init(twist: Twist, error: Twist) {
        self.twist = twist
        self.error = error
    }
}

public func == (lhs: Vector, rhs: Vector) -> Bool {
    return fequal(lhs.x, rhs.x) && fequal(lhs.y, rhs.y) && fequal(lhs.z, rhs.z)
}

public func == (lhs: Twist, rhs: Twist) -> Bool {
    return lhs.angular == rhs.angular && lhs.linear == rhs.linear
}

public func == (lhs: TwistError, rhs: TwistError) -> Bool {
    return lhs.twist == rhs.twist && lhs.error == rhs.error
}
