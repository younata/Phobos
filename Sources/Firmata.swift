import CFirmata

public protocol Firmata {
    func setServo(pin: Int, angle: Int)
    func setPWM(pin: Int, width: Int)

    func analogRead(pin: Int, callback: Double -> Void)
    func digitalRead(pin: Int, callback: Int -> Void)
}

public struct Pin {
    let mode: UInt8 // retype-this
    let analogChannel: UInt8 // retype-this
    let modes: Mode
    let value: UInt32

}

public enum Mode: UInt8 {
    case Input = 0
    case Output = 1
    case Analag = 2
    case PWM = 3
    case Servo = 4
    case Shift = 5
    case i2c = 6
}

enum MessageTypes: UInt8 {
    case StartSysex = 0xF0
    case EndSysex = 0xF7

    case PinModeQuery = 0x72
    case PinModeResponse = 0x73

    case PinStateQuery = 0x6D
    case PinStateResponse = 0x6E

    case CapabilityQuery = 0x6B
    case CapabilityResponse = 0x6C

    case AnalogMappingQuery = 0x69
    case AnalogMappingResponse = 0x6A

    case DigitalMessage = 0x90
    case DigitalReport = 0xC0

    case AnalogMessage = 0xE0
    case AnalogReport = 0xD0

    case SetPinMode = 0xF4

    case Version = 0xF9
    case Reset = 0xFF

    case ServorConfig = 0x70
    case String = 0x71
    case Firmware = 0x79
    case SysexNonRealtime = 0x7E
    case SysexRealtime = 0x7F
}

public final class Firmata23 {

}
