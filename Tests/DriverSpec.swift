import Quick
import Nimble

import Phobos

class DriverSpec: QuickSpec {
    override func spec() {
        var subject: PhoebeDriver!
        var firmata: FakeFirmata!

        beforeEach {
            firmata = FakeFirmata()
            subject = PhoebeDriver(firmata: firmata)
        }

        describe("executing commands") {
            let command = Command(throttle: 1.0, steering: -1.0)

            beforeEach {
                subject.executeCommand(command)
            }

            it("makes two calls to firmata") {
                expect(firmata.setServoCallCount) == 1
                expect(firmata.setPWMCallCount) == 1
            }

            it("tells firmata to adjust the steering servo to the given amount") {
                let (pin, angle) = firmata.setServoArgsForCall(0)

                expect(pin) == 8
                expect(angle) == 0
            }

            it("tells firmata to adjust the throttle servo to the given amount") {
                let (pin, width) = firmata.setPWMArgsForCall(0)

                expect(pin) == 9
                expect(width) == 2500
            }
        }

        describe("retrieving sensor data") {
            var receivedData: Sensor?

            beforeEach {
                subject.sensorState {
                    receivedData = $0
                }
            }

            it("does not immedietely call the callback") {
                expect(receivedData).to(beNil())
            }

            pending("it retrieves sensor data asynchronously") {

            }
        }
    }
}
