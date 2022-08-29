//
//  BasicView.swift
//  sse-pos-ios
//
//  Created by Vlad Z. on 8/28/22.
//

import SwiftUI

struct BasicView: View {
  @StateObject private var viewModel = BasicViewModel()
  
  var columns: [GridItem] = [
    GridItem(.fixed(150)),
    GridItem(.flexible()),
    GridItem(.fixed(150)),
  ]
  
  var body: some View {
    FloatingButtonsView(statusColor: viewModel.state.backgroundColor) {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(viewModel.viewData) { row in
            ZStack {
              RoundedRectangle(cornerRadius: 25,
                               style: .continuous)
              .fill(.indigo)
              
              Text(row.title)
                .font(.caption2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 100, height: 50)
            }
          }
          .padding(.top, 15)
          .padding(.horizontal, 25)
        }
        .padding(.bottom, 100)
        .animation(.easeInOut,
                   value: viewModel.viewData)
      }
    } onTriggerLeft: {
      viewModel.disconnect()
    } onTriggerRight: {
      viewModel.reconnect()
    } onTriggerHeader: {
      viewModel.reset()
    }.task {
      await viewModel.connect()
    }
    .background(Color.white)
  }
}
