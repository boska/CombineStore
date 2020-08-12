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
        Feedback() { state$ in
            Publishers.MergeMany(
                feedbacks.map { $0(state$) }
            )
            .eraseToAnyPublisher()
        }
    }

    public static func scope<A: Equatable>(on keypathA: WritableKeyPath<State, A>,
                                                     _ builder: @escaping (AnyPublisher<A, Never>) -> AnyPublisher<Action, Never>) -> Self {
        Feedback() { state$ in
            builder(
                state$.map(keypathA)
                    .removeDuplicates()
                    .eraseToAnyPublisher()
            )
            .eraseToAnyPublisher()
        }
    }

    public static func scope<A, B>(_ keypathA: WritableKeyPath<State, A>,
                                   _ keypathB:WritableKeyPath<State, B>,
                                   _ builder: @escaping (AnyPublisher<(A, B), Never>) -> AnyPublisher<Action, Never>) -> Self where A: Equatable, B:Equatable {
        Feedback() { state$ in
            let stateA$ = state$.map(keypathA).removeDuplicates()
            let stateB$ = state$.map(keypathB).removeDuplicates()

            let stateAB$ = Publishers.CombineLatest(stateA$, stateB$).eraseToAnyPublisher()
            return builder(stateAB$)
        }
    }

    public static var empty: Self {
        Feedback() { _ in
            Empty().eraseToAnyPublisher()
        }
    }

    public func callAsFunction(_ state$: AnyPublisher<State, Never>) -> AnyPublisher<Action, Never> {
        _closure(state$)
    }

}
