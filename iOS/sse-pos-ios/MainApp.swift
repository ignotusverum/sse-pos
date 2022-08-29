//
//  App.swift
//  sse-pos-ios
//
//  Created by Vlad Z. on 8/28/22.
//

import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            BasicView()
                .tabItem {
                    Label("Basic", systemImage: "note.text")
                    Text("Basic")
                }
        }
    }
}
