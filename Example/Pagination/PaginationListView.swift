//
//  PaginationListView.swift
//  Example
//
//  Created by Yang Lee on 2020/8/9.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import SwiftUI
import CombineStore

struct PaginationListView: View, Dispatchable {
    @StateObject var store = Store<PaginationListState>()

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
                        //                        KFImage(character.imageUrl)
                        //                            .resizable()
                        //                            .cornerRadius(5)
                        //                            .frame(width: 80, height: 80)
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
        }
        //        .alert(isPresented: .constant(state.errorMessage != nil)) {
        //            Alert(title: Text("Oops, something went wrong"),
        //                  message: Text(state.errorMessage ?? ""),
        //                  dismissButton: .default(Text("Got it!")) {
        //                    dispatch(.alertDismissed)
        //                  })
        //        }

    }

}

struct PaginationListView_Previews: PreviewProvider {
    static var previews: some View {
        PaginationListView()
    }
}



