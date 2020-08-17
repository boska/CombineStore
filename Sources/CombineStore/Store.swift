//
//  Store.swift
//  CombineStore
//
//  Created by Yang Lee on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import Combine
import SwiftUI

public final class Store<State: StoreManageable>: ObservableObject {
    @Published public private(set) var state: State
    private let _actions: PassthroughSubject<State.Action, Never> = .init()
    private let _feedbacks: PassthroughSubject<Feedback<State, State.Action>, Never> = .init()
    private var _cancellables: Set<AnyCancellable> = []

    public init(initialState: State = .initialState) {
        state = initialState

        _actions
            .handleEvents(receiveOutput: { action in
                print("🚀 \(action)")
            })
            .compactMap { [weak self] action -> State? in
                guard var newState = self?.state else { return nil }
                State.reducer(&newState, action)
                return newState
            }
            .assign(to: \.state, on: self)
            .store(in: &_cancellables)

        _feedbacks
            .map { [weak self] _ -> AnyPublisher<State.Action, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return State.feedback(self.$state.removeDuplicates().eraseToAnyPublisher())
            }
            .switchToLatest()
            .subscribe(_actions)
            .store(in: &_cancellables)

        _feedbacks.send(State.feedback)
    }

    public func dispatch(_ action: State.Action) {
        _actions.send(action)
    }
}
