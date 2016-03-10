public protocol Driver {
    associatedtype Command
    associatedtype SensorData

    func executeCommand(command: Command)

    func sensorState(callback: SensorData -> Void)
}
