//
//  BasicService.swift
//  sse-pos-ios
//
//  Created by Vlad Z. on 8/28/22.
//

import Combine
import Foundation

enum ServiceEvent<T: Decodable> {
    case initial
    case changedState(StreamState)
    case received(Result<T, Error>)
}

struct RawEvent: Decodable {
    let rawValue: String
}

enum ConnectionType {
    case basic
    var connectionURL: URL {
        URL(string: "http://localhost:3000/countdown")!
    }
}

class StreamClientAdapter<T: Decodable> {
    private let streamClient: StreamClient

    var eventSubject = PassthroughSubject<ServiceEvent<T>, Never>()
    var eventPublisher: AnyPublisher<ServiceEvent<T>, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    init(type: ConnectionType) {
        streamClient = StreamClient(url: type.connectionURL)
        streamClient.onStreamEvent = { [weak self] streamEvent in
            guard let self = self else { return }

            let event: ServiceEvent<T>
            switch streamEvent {
            case let .received(data):
                do {
                    let parsedData = try data.map(to: T.self)
                    event = .received(.success(parsedData))
                } catch {
                    event = .received(.failure(error))
                }
            case let .stateChanged(streamState):
                event = .changedState(streamState)
            }

            DispatchQueue.main.async {
                self.eventSubject.send(event)
            }
        }
    }

    func disconnect() {
        streamClient.disconnect()
    }

    func reconnect() {
        streamClient.connect()
    }
}
