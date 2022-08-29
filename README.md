# iOS Server-Sent Events (SSE) Demo

This repo explores basic implementation for SSE using express.js and representing data sent in the iOS client.

### What are Server-Sent Events?

Server-Sent Events (SSE) is a server push technology enabling a client to receive automatic updates from a server via an HTTP connection and describes how servers can initiate data transmission towards clients once an initial client connection has been established. They are commonly used to send message updates or continuous data streams to a browser client and are designed to enhance native, cross-browser streaming through a JavaScript API called EventSource, through which a client requests a particular URL in order to receive an event stream. The EventSource API is standardized as part of HTML5[1] by the WHATWG. The mime type for SSE is text/event-stream. [1](en.wikipedia.org/wiki/Server-sent_events).

### Overview

While there are a couple of frameworks that layed out the basic implementation for SSE [2](github.com/inaka/EventSource)[3](github.com/launchdarkly/ios-eventsource) I decided to utilize NSURLSession for flexibility and a better understanding of lifecycle that needs to be handled.

[StreamClient.swift](github.com/ignotusverum/sse-pos/blob/main/iOS/sse-pos-ios/Utils/Networking/StreamClient.swift) is responsible for initializing a session per "channel" by passing the URL from which events will come. It uses closure-based API for the simplicity of passing events upstream.

[StreamClientAdapter.swift](github.com/ignotusverum/sse-pos/blob/main/iOS/sse-pos-ios/Utils/Networking/StreamClientAdapter.swift) is responsible for communicating state from StreamClient(connected/closed/connecting) as well as parsing incoming data to desired representations.

One of the use-cases for `StreamClientAdapter` can be found in [BasicViewModel.swift](github.com/ignotusverum/sse-pos/blob/main/iOS/sse-pos-ios/Features/Basic/BasicViewModel.swift#L43-L58) where we are connecting to pre-defined URL during initialization phase and subscribing to events that are passed to the view layer.

## Demo 


## How to run

1. Open [API] folder & run `npm instlal`
2. run `node API/API.js`
3. open `.xcodeproj` & run