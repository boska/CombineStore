//
//  AppState.swift
//  Example
//
//  Created by Yang Lee on 2020/8/10.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import Combine
import CombineStore

struct AppState: StoreManageable {
    var counter: CounterState
    var paginationList: PaginationListState

    enum Action {
        case counter(CounterState.Action)
        case paginationList(PaginationListState.Action)
    }

    static var initialState: AppState {
        .init(counter: .initialState,
              paginationList: .initialState)
    }

    static var reducer: Reducer<AppState, Action> {
        .init { state, action in
            switch action {
            case .counter(let action):
                CounterState.reducer(&state.counter, action)
            case .paginationList(let action):
                PaginationListState.reducer(&state.paginationList, action)
            }
        }
    }

    static var feedback: Feedback<AppState, Action> {
        .init { states in
            let counterActions = CounterState.feedback(states.map(\.counter).eraseToAnyPublisher())
                .map { AppState.Action.counter($0) }
                .eraseToAnyPublisher()
            
            let paginationListActions = PaginationListState.feedback(states.map(\.paginationList).eraseToAnyPublisher())
                .map { AppState.Action.paginationList($0) }
                .eraseToAnyPublisher()

            return Publishers.MergeMany([
                counterActions,
                paginationListActions
            ])
            .eraseToAnyPublisher()
        }
    }

}
