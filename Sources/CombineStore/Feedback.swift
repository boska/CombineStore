//
//  Feedback.swift
//  CombineStore
//
//  Created by Yang Lee on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import Combine

public struct Feedback<State, Action> {
    public typealias Closure = (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
    private let _closure: Closure

    public init(_ _closure: @escaping Closure) {
        self._closure = _closure
    }

    public static func merge(_ feedbacks: [Self]) -> Self {
        Feedback() { states in
            Publishers.MergeMany(
                feedbacks.map { $0(states) }
            )
            .eraseToAnyPublisher()
        }
    }

    public static func scope<ScopedState: Equatable>(on stateKeyPath: WritableKeyPath<State, ScopedState>,
                                                     _ scopedfeedback: @escaping (AnyPublisher<ScopedState, Never>) -> AnyPublisher<Action, Never>) -> Self {
        Feedback() { states in
            scopedfeedback(
                states.map(stateKeyPath)
                    .removeDuplicates()
                    .eraseToAnyPublisher()
            )
            .eraseToAnyPublisher()
        }
    }

    public static var empty: Self {
        Feedback() { _ in
            Empty().eraseToAnyPublisher()
        }
    }

    func callAsFunction(_ state: AnyPublisher<State, Never>) -> AnyPublisher<Action, Never> {
        _closure(state)
    }

}
