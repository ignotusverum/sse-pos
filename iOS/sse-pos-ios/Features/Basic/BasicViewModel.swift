//
//  BasicViewModel.swift
//  sse-pos-ios
//
//  Created by Vlad Z. on 8/28/22.
//

import Foundation
import Combine
import SwiftUI

enum VMState<T> {
  case loading
  case viewData(T)
}

struct BasicViewData: Identifiable, Equatable {
  let id: UUID
  let title: String
}

class BasicViewModel: ObservableObject {
  @Published var viewData: [BasicViewData] = []
  @Published var state: StreamState = .connecting
  @Published var streamClient: StreamClientAdapter = StreamClientAdapter<RawEvent>(type: .basic)
  
  private var cancellables: Set<AnyCancellable> = []
  
  func reconnect() {
    streamClient.reconnect()
  }
  
  func reset() {
    viewData = []
  }
  
  func disconnect() {
    streamClient.disconnect()
  }
  
  @MainActor
  func connect() async {
    streamClient
      .eventPublisher
      .sink { [weak self] event in
        guard let self = self else { return }
        switch event {
        case .initial,
            .received(.failure):
          break
        case let .received(.success(eventValue)):
          self.viewData.append(.init(id: .init(),
                                     title: eventValue.rawValue))
        case let .changedState(streamState):
          self.state = streamState
        }
      }
      .store(in: &cancellables)
  }
}
