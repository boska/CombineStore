//
//  PaginationListState.swift
//  Example
//
//  Created by Yang Lee on 2020/8/9.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import Combine
import CombineExt
import CombineStore
import Foundation

struct PaginationListState: StoreManageable {
    var results: [Character] = []
    var pagination: Pagination?
    var errorMessage: String?
    var searchTerm: String = ""
    var isLoading = false

    enum Action {
        case searchTermDidChange(String)
        case responseReceived(CharactersResponse)
        case errorOccurred(APIError)
        case alertDismissed
        case loadMore
    }

    static var initialState: PaginationListState {
        .init()
    }

    static func reducer(_ state: inout PaginationListState, _ action: Action) {
        switch action {
        case let .responseReceived(response):
            state.pagination = response.info

            if state.pagination?.prev == nil {
                state.results = response.results
            } else {
                state.results += response.results
            }

            state.isLoading = false

        case let .errorOccurred(error):
            state.errorMessage = error.localizedDescription

        case .alertDismissed:
            state.errorMessage = nil

        case let .searchTermDidChange(newTerm):
            state.searchTerm = newTerm
            state.pagination = nil

        case .loadMore:
            state.isLoading = true
        }
    }

    static var feedback: Feedback<PaginationListState> {
        .merge([
            loadPage,
            debouncedSearch,
        ])
    }

    private static var loadPage: Feedback<PaginationListState> {
        .init { states in
            states
                .map(\.isLoading)
                .filter { $0 }
                .withLatestFrom(states)
                .map {
                    PaginationListApi
                        .getCharacters(by: $0.searchTerm, page: $0.pagination?.next ?? 1)
                        .map { .responseReceived($0) }
                        .catch { Just(.errorOccurred($0)) }
                        .receive(on: DispatchQueue.main)
                }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }

    private static var debouncedSearch: Feedback<PaginationListState> {
        .scope(on: \.searchTerm) { searchTerms in
            searchTerms
                .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
                .map { _ in .loadMore }
                .dropFirst()
                .eraseToAnyPublisher()
        }
    }
}
