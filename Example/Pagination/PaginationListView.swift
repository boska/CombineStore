//
//  PaginationListView.swift
//  Example
//
//  Created by Yang Lee on 2020/8/9.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import SwiftUI
import CombineStore

struct PaginationListView: View {
    @StateObject var store = Store<AppState>()
    @State var state = PaginationListState()

//    var state: PaginationListState {
//        store.state[keyPath: \.paginationList]
//    }

    func dispatch(_ action: PaginationListState.Action) {
        store.dispatch(.paginationList(action))
    }

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: .init(
                        get: { state.searchTerm },
                        set: { dispatch(.searchTermDidChange($0)) }
                    ))
                }

                ForEach(state.results, id: \.id) { character in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(character.name).fontWeight(.bold)
                            Text(character.species).fontWeight(.light)
                        }
                    }
                }

                ProgressView()
                    .onAppear { dispatch(.loadMore) }
            }
            .navigationBarTitle(Text("Pagination"))
            .onReceive(store.$state.map(\.paginationList)) {
                state = $0
            }
        }
    }
}

struct PaginationListView_Previews: PreviewProvider {
    static var previews: some View {
        PaginationListView()
    }
}



