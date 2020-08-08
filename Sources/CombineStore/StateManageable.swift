//
//  StateManageable.swift
//  CombineStore
//
//  Created by Yang on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

public protocol StateManageable {
    associatedtype Action

    static var initialState: Self { get }
    static var reducer: Reducer<Self, Self.Action> { get } // (inout State, Action) -> Void
    static var feedback: Feedback<Self, Self.Action> { get } // (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
}

extension StateManageable {
    static var feedback: Feedback<Self, Self.Action> {
        .empty
    }
}
