//import Result
import Jay

public enum Result<T, U: ErrorType> {
    case Success(T)
    case Failure(U)
}

public final class Subscriber: Equatable {
    private let client: Client

    private var topicMessages: [Topic: Result<[UInt8], PhobosError> -> Void] = [:]

    public init(client: Client) {
        self.client = client
    }

    public func listen<T: Serializable>(topic: Topic, callback: Result<T, PhobosError> -> Void) {
        self.topicMessages[topic] = { result in
            switch result {
            case let .Success(bytes):
                if let json = (try? Jay().jsonFromData(bytes)) as? [String: Any], let object = T(json: json) {
                    callback(.Success(object))
                } else {
                    callback(.Failure(.Deserialize))
                }
            case let .Failure(error):
                callback(.Failure(error))
            }
        }

        self.client.subscribe(topic, subscriber: self)
    }

    public func stopListening(topic: Topic){
        self.client.unsubscribe(topic, subscriber: self)
    }

    public func client(client: Client, topic: Topic, didReturnResult result: Result<[UInt8], PhobosError>) {
        self.topicMessages[topic]?(result)
    }
}

public func ==(lhs: Subscriber, rhs: Subscriber) -> Bool {
    return lhs === rhs
}

public struct Publisher<T: Serializable> {
    private let client: Client

    public init(client: Client) {
        self.client = client
    }

    public func publish(topic: Topic, message: T) {
        let data = try! Jay().dataFromJson(message.serialize())
        self.client.publish(topic, data: data)
    }
}

public protocol Client {
    func publish(topic: Topic, data: [UInt8])

    func subscribe(topic: Topic, subscriber: Subscriber)
    func unsubscribe(topic: Topic, subscriber: Subscriber)
}
