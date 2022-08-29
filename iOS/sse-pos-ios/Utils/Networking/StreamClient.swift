//
//  AmexNetwork.swift
//  sse-pos-ios
//
//  Created by Vlad Z. on 8/28/22.
//

import Foundation
import SwiftUI

enum StreamState {
    case connecting
    case open
    case closed

    var backgroundColor: Color {
        switch self {
        case .open: return .green
        case .connecting: return .yellow
        case .closed: return .red
        }
    }
}

enum StreamEvent {
    case received(Data)
    case stateChanged(StreamState)
}

class StreamClient: NSObject {
    let url: URL
    var state: StreamState = .closed {
        didSet {
            onStreamEvent?(.stateChanged(state))
        }
    }
    private var urlSession: URLSession? = nil
    private var defaultHeaders: [String: String] {
        ["Content-Type": "text/event-stream",
         "Cache-Control": "no-cache",
         "Connection": "keep-alive"]

    }

    var onStreamEvent: ((StreamEvent)-> ())? = nil

    init(url: URL) {
        self.url = url
        super.init()

        onStreamEvent?(.stateChanged(state))
        connect()
    }

    func connect() {
        state = .connecting

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(INT_MAX)
        sessionConfiguration.timeoutIntervalForResource = TimeInterval(INT_MAX)
        sessionConfiguration.httpAdditionalHeaders = defaultHeaders

        let sessionOperationQueue = OperationQueue()
        sessionOperationQueue.maxConcurrentOperationCount = 1

        urlSession = URLSession(configuration: sessionConfiguration,
                                delegate: self,
                                delegateQueue: sessionOperationQueue)
        urlSession?.dataTask(with: url).resume()
    }

    func disconnect() {
        state = .closed
        urlSession?.invalidateAndCancel()
    }
}

extension StreamClient: URLSessionDataDelegate {
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        guard state == .open else { return }
        onStreamEvent?(.received(data))
    }

    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        state = .open
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        state = .closed
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
    }
}
