import Quick
import Nimble
import Phobos

final class TypesSpec: QuickSpec {
    override func spec() {
        describe("Vector") {
            it("is deserializable from a json dictionary") {
                let json = ["x": 3.5, "y": 2.5, "z": 4.5]
                let expected = Vector(x: 3.5, y: 2.5, z: 4.5)
                expect(Vector(json: json)) == expected
            }

            it("serializes to json") {
                let expected = ["x": 3.5, "y": 2.5, "z": 4.5]
                let subject = Vector(x: 3.5, y: 2.5, z: 4.5)
                expect(subject.serialize()) == expected
            }

            it("can deserialize itself from it's own serialization") {
                let subject = Vector(x: 3.5, y: 2.5, z: 4.5)
                expect(Vector(json: subject.serialize())) == subject
            }
        }

        describe("Twist") {
            let angularJson = ["x": 3.5, "y": 2.5, "z": 4.5]
            let linearJson = ["x": 1.25, "y": 1.75, "z": 2.25]
            let json = ["angular": angularJson, "linear": linearJson]

            let angular = Vector(x: 3.5, y: 2.5, z: 4.5)
            let linear = Vector(x: 1.25, y: 1.75, z: 2.25)

            let subject = Twist(angular: angular, linear: linear)

            it("is deserializable from a json dictionary") {
                expect(Twist(json: json)) == subject
            }

            it("serializes to json") {
                expect(subject.serialize()) == json
            }

            it("can deserialize itself from it's own serialization") {
                expect(Twist(json: subject.serialize())) == subject
            }
        }

        describe("TwistError") {
            let angularJson = ["x": 3.5, "y": 2.5, "z": 4.5]
            let linearJson = ["x": 1.25, "y": 1.75, "z": 2.25]
            let twistJson = ["angular": angularJson, "linear": linearJson]

            let angularErrorJson = ["x": 0.1, "y": 0.2, "z": 0.3]
            let linearErrorJson = ["x": 0.01, "y": 0.02, "z": 0.03]
            let errorJson = ["angular": angularJson, "linear": linearJson]

            let angular = Vector(x: 3.5, y: 2.5, z: 4.5)
            let linear = Vector(x: 1.25, y: 1.75, z: 2.25)
            let twist = Twist(angular: angular, linear: linear)

            let angularError = Vector(x: 0.1, y: 0.2, z: 0.3)
            let linearError = Vector(x: 0.01, y: 0.02, z: 0.03)
            let error = Twist(angular: angularError, linear: linearError)

            let json = ["twist": twistJson, "error": errorJson]

            let subject = TwistError(twist: twist, error: error)

            it("is deserializable from a json dictionary") {
                expect(TwistError(json: json)) == subject
            }

            it("serializes to json") {
                expect(subject.serialize()) == json
            }

            it("can deserialize itself from it's own serialization") {
                expect(TwistError(json: subject.serialize())) == subject
            }
        }
    }
}
