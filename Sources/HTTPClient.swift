import Vapor

public final class HTTPClient: Client, RouterDriver {
    private var subscribers: [Topic: [Subscriber]] = [:]
    private var application: Application!
    private var foreignSubscribers: [Topic] = []

    public static let sharedClient = HTTPClient()

    internal init(setApp: Bool = true) {
        self.application = Application(router: self)
        self.application.start()
    }

    // MARK: - Client
    public func publish(topic: Topic, data: [UInt8]) {
        // make a POST request
        let localTopic = Topic(topic.path)

        self.informSubscribers(localTopic, data: data)
    }

    public func subscribe(topic: Topic, subscriber: Subscriber) {
        let subscribers: [Subscriber]
        if let topicSubscribers = self.subscribers[topic]  {
            subscribers = topicSubscribers + [subscriber]
        } else {
            subscribers = [subscriber]
        }
        self.subscribers[topic] = subscribers
    }

    public func unsubscribe(topic: Topic, subscriber: Subscriber) {
        self.subscribers[topic] = self.subscribers[topic]?.filter({ $0 == subscriber }) ?? []
    }

    // MARK: - RouterDriver

    public let supportsKeepAlive = true

    public func route(request: Request) -> Request.Handler? {
        let host = request.headers["X-Phobos-Requester"] ?? request.address ?? "localhost"
        let topic = Topic(hostname: host, path: request.path)
        switch request.method {
            case .Post:
                let body = request.body
                self.informSubscribers(topic, data: body)
                return { _ in
                    return Response(status: .OK, data: [], contentType: .None)
                }
            case .Put:
                self.addForeignSubscriber(topic)
                return { _ in
                    return Response(status: .OK, data: [], contentType: .None)
                }
            case .Delete:
                let status: Response.Status = self.removeForeignSubscriber(topic) ? .OK : .NotFound
                return { _ in
                    return Response(status: status, data: [], contentType: .None)
                }
            default: return nil
        }
    }

    public func register(route: Route) {
        // ?
    }

    // MARK: - Private

    private func informSubscribers(topic: Topic, data: [UInt8]) {
        if let subscribers = self.subscribers[topic] {
            subscribers.forEach { $0.client(self, topic: topic, didReturnResult: .Success(data)) }
        }
    }

    private func addForeignSubscriber(topic: Topic) {
        self.foreignSubscribers.append(topic)
    }

    private func removeForeignSubscriber(topic: Topic) -> Bool {
        if let index = self.foreignSubscribers.indexOf(topic) {
            self.foreignSubscribers.removeAtIndex(index)
            return true
        }
        return false
    }
}
