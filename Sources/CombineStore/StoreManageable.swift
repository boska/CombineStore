//
//  StoreManageable.swift
//  CombineStore
//
//  Created by Yang Lee on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

public protocol StoreManageable: Equatable {
    associatedtype Action

    static var initialState: Self { get }

    static func reducer(_ state: inout Self, _ action: Action)

    static var feedback: Feedback<Self> { get } // (AnyPublisher<State, Never>) -> AnyPublisher<Action, Never>
}

extension StoreManageable {
    static var feedback: Feedback<Self> {
        .empty
    }
}
