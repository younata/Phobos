import Quick
import Nimble
import Jay
import Phobos

final class CommunicationsSpec: QuickSpec {
    override func spec() {
        var client: FakeClient!
        let topic = "test"
        beforeEach {
            client = FakeClient()
        }

        describe("Subscriber") {
            var subject: Subscriber!
            beforeEach {
                subject = Subscriber(client: client)
            }

            describe("listening for messages") {
                var receivedMessages: [Result<Vector, PhobosError>] = []

                beforeEach {
                    receivedMessages = []
                    subject.listen(topic) {
                        receivedMessages.append($0)
                    }
                }

                it("asks the client to subscribe to the topic on it's behalf") {
                    expect(client.subscribeCallCount) == 1
                    expect(client.subscribeArgsForCall(0).0) == topic
                }

                context("when the client gets a message that can be deserialized") {
                    it("deserializes the message and informs the user") {
                        let subscriber = client.subscribeArgsForCall(0).1
                        let json = ["x": 3.5, "y": 2.5, "z": 4.5]
                        let data = try! Jay().dataFromJson(json)
                        subscriber.client(client, topic: topic, didReturnResult: .Success(data))
                    }
                }

                context("when the client gets a message that cannot be deserialized") {
                    it("informs the user") {
                        let subscriber = client.subscribeArgsForCall(0).1
                        subscriber.client(client, topic: topic, didReturnResult: .Success([]))

                        expect(receivedMessages.last) == .Failure(.Deserialize)
                    }
                }

                context("when the client runs into an error") {
                    it("informs the user") {
                        let subscriber = client.subscribeArgsForCall(0).1
                        subscriber.client(client, topic: topic, didReturnResult: .Failure(.NetworkError))

                        expect(receivedMessages.last) == .Failure(.NetworkError)
                    }
                }
            }

            it("no-ops if it tries to unsubscribe from a topic it's not subscribed to") {
                expect(subject.stopListening("test")).toNot(throwError())
            }
        }

        describe("Publisher") {
            var subject: Publisher<Vector>!
            beforeEach {
                subject = Publisher<Vector>(client: client)
            }

            describe("publishing messages") {
                it("serializes the object and sends the data to the client") {
                    let vector = Vector(x: 3.5, y: 2.5, z: 4.5)
                    subject.publish(topic, vector)

                    expect(client.publishCallCount) == 1
                    expect(client.publishArgsForCall(0).0) == topic
                    expect(client.publishArgsForCall(0).1) == try! Jay().dataFromJson(vector.serialize())
                }
            }
        }
    }
}
