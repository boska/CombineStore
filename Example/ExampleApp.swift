//
//  ExampleApp.swift
//  Example
//
//  Created by Yang Lee on 2020/8/6.
//

import CombineStore
import SwiftUI

@main
struct ExampleApp: App {
    @StateObject var store = Store<AppState>()
    var body: some Scene {
        WindowGroup {
            TabView {
                CounterView()
                    .tabItem { Text("Counter") }

                PaginationListView()
                    .tabItem { Text("Pagination") }
            }
            .environmentObject(store)
        }
    }
}
