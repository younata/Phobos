public enum PhobosError: ErrorType {
    case Network
    case Serialize
    case Deserialize
}

public protocol Serializable {
    init?(json: [String: Any])

    func serialize() -> [String: Any]
}

/// Time in seconds
public typealias TimeInterval = Double

/**
 Represents a 3d vector, unitless
 */
public struct Vector: Equatable, Serializable {
    public let x: Double
    public let y: Double
    public let z: Double

    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init?(json: [String: Any]) {
        guard let x = json["x"] as? Double, y = json["y"] as? Double, z = json["z"] as? Double else { return nil }
        self.init(x: x, y: y, z: z)
    }

    public func serialize() -> [String: Any] {
        return [
            "x": self.x,
            "y": self.y,
            "z": self.z
        ]
    }
}

/**
 Combines Linear and Angular vectors
 */
public struct Twist: Equatable, Serializable {
    public let angular: Vector
    public let linear: Vector

    public init(angular: Vector, linear: Vector) {
        self.angular = angular
        self.linear = linear
    }

    public init?(json: [String: Any]) {
        guard let angularJson = json["angular"] as? [String: Any], linearJson = json["linear"] as? [String: Any],
              angular = Vector(json: angularJson), linear = Vector(json: linearJson) else { return nil }
        self.init(angular: angular, linear: linear)
    }

    public func serialize() -> [String: Any] {
        return [
            "angular": self.angular.serialize(),
            "linear": self.linear.serialize()
        ]
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

    public init?(json: [String: Any]) {
        guard let twistJson = json["twist"] as? [String: Any], errorJson = json["error"] as? [String: Any],
              twist = Twist(json: twistJson), error = Twist(json: errorJson) else { return nil }
        self.init(twist: twist, error: error)
    }

    public func serialize() -> [String: Any] {
        return [
            "twist": self.twist.serialize(),
            "error": self.error.serialize(),
        ]
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
