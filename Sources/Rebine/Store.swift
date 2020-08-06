//
//  Store.swift
//  Rebine
//
//  Created by Yang on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//


import Combine
import SwiftUI

public final class Store<State, Action> {
    private let _states: CurrentValueSubject<State, Never>
    private let _actions: PassthroughSubject<Action, Never> = .init()
    private let _feedbacks: PassthroughSubject<Feedback<State, Action>, Never> = .init()
    private var _cancellables: Set<AnyCancellable> = []
    public convenience init<RC: RebineCompatible>(_ rcType: RC.Type) where RC.State == State, RC.Action == Action {
        self.init(initialState: rcType.initialValue,
                  reducer: rcType.reducer,
                  feedback: rcType.feedback)
    }
    public init(
        initialState: State,
        reducer: Reducer<State, Action>,
        feedback: Feedback<State, Action>
    ) {
        _states = CurrentValueSubject(initialState)

        _actions
            .handleEvents(receiveOutput: { action in
                print("🚀 \(action)")
            })
            .compactMap { [weak self] action -> State? in
                guard var newState = self?._states.value else { return nil }
                reducer(&newState, action)
                return newState
            }
            .subscribe(_states)
            .store(in: &_cancellables)

        _feedbacks
            .map { [weak self] feedback -> AnyPublisher<Action, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return feedback(self._states.eraseToAnyPublisher())
            }
            .switchToLatest()
            .subscribe(_actions)
            .store(in: &_cancellables)

        _feedbacks.send(feedback)

    }
}

extension Store {
    public var statePublisher: AnyPublisher<State, Never> {
        _states.eraseToAnyPublisher()
    }

    public func dispatch(_ action: Action) {
        _actions.send(action)
    }
}

extension Store: ObservableObject {}


