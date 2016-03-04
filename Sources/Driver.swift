public protocol Driver {
    associatedtype Command
    associatedtype SensorData

    func executeCommand(command: Command)

    func sensorState(callback: SensorData -> Void)
}

public protocol Firmata {
    func setServo(pin: Int, angle: Int)
    func setPWM(pin: Int, width: Int)

    func analogRead(pin: Int, callback: Double -> Void)
    func digitalRead(pin: Int, callback: Int -> Void)
}

public struct Command: Equatable {
    public let throttle: Double
    public let steering: Double

    public init(throttle: Double, steering: Double) {
        self.throttle = clamp(throttle, min: -1.0, max: 1.0)
        self.steering = clamp(steering, min: -1.0, max: 1.0)
    }
}

public func == (lhs: Command, rhs: Command) -> Bool {
    return fequal(lhs.throttle, rhs.throttle) && fequal(lhs.steering, rhs.steering)
}

public struct Sensor {
    public let position: TwistError
    public let velocity: TwistError
    public let acceleration: TwistError

    public let timestamp: TimeInterval

    init(position: TwistError, velocity: TwistError, acceleration: TwistError, timestamp: TimeInterval) {
        self.position = position
        self.velocity = velocity
        self.acceleration = acceleration

        self.timestamp = timestamp
    }
}

public func == (lhs: Sensor, rhs: Sensor) -> Bool {
    return lhs.position == rhs.position && lhs.velocity == rhs.velocity &&
        lhs.acceleration == rhs.acceleration && lhs.timestamp == rhs.timestamp
}

public struct PhoebeDriver: Driver {
    public typealias Command = Phobos.Command
    public typealias SensorData = Phobos.Sensor

    private let steeringPin = 8
    private let throttlePin = 9

    private let firmata: Firmata
    public init(firmata: Firmata) {
        self.firmata = firmata
    }

    public func executeCommand(command: Command) {
        let steering = (command.steering + 1.0) / 2.0
        self.firmata.setServo(self.steeringPin, angle: Int(map(steering, min: 0, max: 180)))

        let throttle = (command.throttle + 1.0) / 2.0
        self.firmata.setPWM(self.throttlePin, width: Int(map(throttle, min: 1500, max: 2500)))
    }

    public func sensorState(callback: SensorData -> Void) {

    }
}
