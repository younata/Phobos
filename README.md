## Phobos - Robotics framework in Swift

Phobos is a ROS-inspired framework for doing robotics in Swift.

Networking:

Current implementation for the Phobos communication protocol looks as follows:

A program can subscribe to a topic by sending a PUT request to the topic they want to subscribe to. I.E. to subscribe to the /foo/bar topic on host example.com, send a PUT request to example.com/foo/bar

A program can publish messages by sending POST requests to servers with the message data serialized to JSON. I.E. send a POST with body data {"x": 1} to example.com/foo/bar

A program can unsubscribe to topics by sending a DELETE request to the topic on the host, I.E. DELETE example.com/foo/bar
