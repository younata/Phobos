import Result
import Jay

public enum Result<T, U: ErrorType> {
    case Success(T)
    case Failure(U)
}

public final class Subscriber {
    private let client: Client

    private var topicMessages: [String: Result<[UInt8], PhobosError> -> Void] = [:]

    public init(client: Client) {
        self.client = client
    }

    public func listen<T: Serializable>(topic: String, callback: Result<T, PhobosError> -> Void) {
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

    public func stopListening(topic: String){
        self.client.unsubscribe(topic, subscriber: self)
    }

    public func client(client: Client, topic: String, didReturnResult result: Result<[UInt8], PhobosError>) {
    }
}

public struct Publisher<T: Serializable> {
    private let client: Client

    public init(client: Client) {
        self.client = client
    }

    public func publish(topic: String, message: T) {
        let data = try! Jay().dataFromJson(message.serialize())
        self.client.publish(topic, data: data)
    }
}

public protocol Client {
    func publish(topic: String, data: [UInt8])

    func subscribe(topic: String, subscriber: Subscriber)
    func unsubscribe(topic: String, subscriber: Subscriber)
}
