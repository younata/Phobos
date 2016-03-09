import Phobos

class FakeClient: Client {
    init() {
    }

    private(set) var publishCallCount : Int = 0
    private var publishArgs : Array<(String, [UInt8])> = []
    func publishArgsForCall(callIndex: Int) -> (String, [UInt8]) {
        return self.publishArgs[callIndex]
    }
    func publish(topic: String, data: [UInt8]) {
        self.publishCallCount += 1
        self.publishArgs.append((topic, data))
    }

    private(set) var subscriberCallCount : Int = 0
    private var subscribeArgs : Array<(String, Subscriber)> = []
    func subscribeArgsForCall(callIndex: Int) -> (String, Subscriber) {
        return self.subscribeArgs[callIndex]
    }
    func subscribe(topic: String, subscriber: Subscriber) {
        self.subscriberCallCount += 1
        self.subscriberArgs.append((topic, subscriber))
    }

    private(set) var unsubscribeCallCount : Int = 0
    private var unsubscribeArgs : Array<(String, Subscriber)> = []
    func unsubscribeArgsForCall(callIndex: Int) -> (String, Subscriber) {
        return self.unsubscribeArgs[callIndex]
    }
    func unsubscribe(topic: String, subscriber: Subscriber) {
    }
}
