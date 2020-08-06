//
//  Rebine.swift
//  Rebine
//
//  Created by Yang on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

public protocol RebineCompatible {
    associatedtype State
    associatedtype Action

    static var initialValue: State { get }
    static var reducer: Reducer<State, Action> { get }
    static var feedback: Feedback<State, Action> { get }
}

extension RebineCompatible {
    static var feedback: Feedback<State, Action> {
        .empty
    }
}
