//
//  FloatingButtonsView.swift
//  sse-pos-ios
//
//  Created by Vlad Z. on 8/29/22.
//

import SwiftUI

struct FloatingButtonsView<Content: View>: View {
    @ViewBuilder var content: Content

    var statusColor: Color
    let onTriggerLeft: () -> Void
    let onTriggerRight: () -> Void

    init(statusColor: Color,
         @ViewBuilder content: @escaping () -> Content,
         onTriggerLeft: @escaping () -> Void,
         onTriggerRight: @escaping () -> Void) {
        self.content = content()
        self.statusColor = statusColor
        self.onTriggerLeft = onTriggerLeft
        self.onTriggerRight = onTriggerRight
    }

    var body: some View {
        ZStack(alignment: .bottom) {
          VStack(spacing: 0) {
                statusColor
                    .animation(.easeInOut, value: statusColor)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 20)

                content
            }

            HStack {
                Button(action: {
                    onTriggerLeft()
                }) {
                    Image(systemName:  "stop")
                        .foregroundColor(.red)
                }
                .frame(width: 50,
                       height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.4),
                                radius: 1,
                                x: 0,
                                y: 1)
                )

                Spacer()

                Button(action: {
                    onTriggerRight()
                }) {
                    Image(systemName:  "play")
                        .foregroundColor(.green)
                }
                .frame(width: 50,
                       height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.4),
                                radius: 1,
                                x: 0,
                                y: 1)
                )
            }
            .padding(25)
        }
    }
}
