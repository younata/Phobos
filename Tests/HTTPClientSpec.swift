import Quick
import Nimble
import Jay
@testable import Phobos

final class HTTPClientSpec: QuickSpec {
    override func spec() {
        var subject: HTTPClient!

        beforeEach {
            subject = HTTPClient(setApp: false)
        }

        describe("publish") {
            pending("makes a POST request to any servers subscribing to this") {
            }

            it("informs any subscribers listening in on the topic name for this server") {
                let subscriber = Subscriber<Vector>(client: subject)
                var receivedMessages: [Result<Vector, PhobosError>] = []
                subscriber.listen(Topic("test")) {
                    receivedMessages.append($0)
                }

                let otherSubscriber = Subscriber<Vector>(client: subject)
                var otherReceivedMessages: [Result<Vector, PhobosError>] = []
                otherSubscriber.listen(Topic(hostname: "example.com", path: "test")) {
                    receivedMessages.append($0)
                }

                subject.publish("test", try! Jay().dataFromJson(Vector(x: 1, y: 1, z: 1).serialize()))
                expect(receivedMessages.count) == 1

                expect(otherReceivedMessages.count) == 0
            }
        }

        describe("subscribing to a topic") {
            context("on a separate server") {
                pending("makes a put request to the other server") {
                }
            }

            context("on this server") {
                pending("does not make any requests to a server") {
                }
            }
        }

        describe("unsubscribing to a topic") {
            context("on a separate server") {
                pending("it makes a DELETE request to the other server") {
                }
            }

            context("on this server") {
                pending("does not make any requests to any server") {
                }

                it("no longer receives messages") {
                    let subscriber = Subscriber<Vector>(client: subject)
                    var receivedMessages: [Result<Vector, PhobosError>] = []
                    subscriber.listen(Topic("test")) {
                        receivedMessages.append($0)
                    }

                    subscriber.stopListening(Topic("test"))

                    subject.publish("test", try! Jay().dataFromJson(Vector(x: 1, y: 1, z: 1).serialize()))
                    expect(receivedMessages.count) == 0
                }
            }
        }

        describe("routing a request") {
            describe("POST requests") { // informing us of a new message
                it("informs any subscribers") {
                }
            }

            describe("PUT requests") { // Interested in this topic
                it("adds foreign subscriber to this topic") {
                }
            }

            describe("DELETE requests") { // no longer interested in this topic
                it("removes the foreign subscriber of this topic") {
                }
            }
        }
    }
}
