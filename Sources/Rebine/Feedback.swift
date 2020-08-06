//
//  Feedback.swift
//  Rebine
//
//  Created by Yang on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import Combine

public struct Feedback<State, Action> {
    public typealias Closure = (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
    private let feedbackClosure: Closure

    public init(_ feedbackClosure: @escaping Closure) {
        self.feedbackClosure = feedbackClosure
    }

    func callAsFunction(_ state: AnyPublisher<State, Never>) -> AnyPublisher<Action, Never> {
        feedbackClosure(state)
    }

    static var empty: Self {
        Feedback() { _ in
            Empty().eraseToAnyPublisher()
        }
    }
}
