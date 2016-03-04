import Phobos

final class FakeFirmata : Firmata {
    init() {
    }

    private(set) var setServoCallCount : Int = 0
    private var setServoArgs : Array<(Int, Int)> = []
    func setServoArgsForCall(callIndex: Int) -> (Int, Int) {
        return self.setServoArgs[callIndex]
    }
    func setServo(pin: Int, angle: Int) {
        self.setServoCallCount += 1
        self.setServoArgs.append((pin, angle))
    }

    private(set) var setPWMCallCount : Int = 0
    private var setPWMArgs : Array<(Int, Int)> = []
    func setPWMArgsForCall(callIndex: Int) -> (Int, Int) {
        return self.setPWMArgs[callIndex]
    }
    func setPWM(pin: Int, width: Int) {
        self.setPWMCallCount += 1
        self.setPWMArgs.append((pin, width))
    }

    private(set) var analogReadCallCount : Int = 0
    private var analogReadArgs : Array<(Int, Double -> Void)> = []
    func analogReadArgsForCall(callIndex: Int) -> (Int, Double -> Void) {
        return self.analogReadArgs[callIndex]
    }
    func analogRead(pin: Int, callback: Double -> Void) {
        self.analogReadCallCount += 1
        self.analogReadArgs.append((pin, callback))
    }

    private(set) var digitalReadCallCount : Int = 0
    private var digitalReadArgs : Array<(Int, Int -> Void)> = []
    func digitalReadArgsForCall(callIndex: Int) -> (Int, Int -> Void) {
        return self.digitalReadArgs[callIndex]
    }
    func digitalRead(pin: Int, callback: Int -> Void) {
        self.digitalReadCallCount += 1
        self.digitalReadArgs.append((pin, callback))
    }

    static func reset() {
    }
}