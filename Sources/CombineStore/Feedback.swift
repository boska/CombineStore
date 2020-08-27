//
//  Feedback.swift
//  CombineStore
//
//  Created by Yang Lee on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import Combine
import Foundation

public struct Feedback<State: StoreManageable> {
    public typealias Action = State.Action
    public typealias Closure = (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
    private let _closure: Closure

    public init(_ closure: @escaping Closure) {
        _closure = closure
    }

    public static func merge(_ feedbacks: [Self]) -> Self {
        Feedback { state$ in
            Publishers.MergeMany(
                feedbacks.map { $0(state$) }
            )
            .eraseToAnyPublisher()
        }
    }

    public static func scope<A>(on keypathA: WritableKeyPath<State, A>,
                                _ builder: @escaping (AnyPublisher<A, Never>) -> AnyPublisher<Action, Never>) -> Self {
        Feedback { state$ in
            builder(
                state$.map(keypathA).eraseToAnyPublisher()
            )
            .eraseToAnyPublisher()
        }
    }

    public static func scope<A, B>(_ keypathA: WritableKeyPath<State, A>,
                                   _ keypathB: WritableKeyPath<State, B>,
                                   _ builder: @escaping (AnyPublisher<(A, B), Never>) -> AnyPublisher<Action, Never>) -> Self {
        Feedback { state$ in
            let stateA$ = state$.map(keypathA)
            let stateB$ = state$.map(keypathB)

            let stateAB$ = Publishers.CombineLatest(stateA$, stateB$).eraseToAnyPublisher()
            return builder(stateAB$)
        }
    }

    public static var empty: Self {
        Feedback { _ in
            Empty().eraseToAnyPublisher()
        }
    }

    public func callAsFunction(_ state$: AnyPublisher<State, Never>) -> AnyPublisher<Action, Never> {
        _closure(state$)
    }
}
