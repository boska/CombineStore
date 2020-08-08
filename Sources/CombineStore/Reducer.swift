//
//  Reducer.swift
//  CombineStore
//
//  Created by Yang on 2020/8/2.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import Foundation

public struct Reducer<State, Action> {
    public typealias Closure = (inout State, Action) -> Void
    private let _closure: Closure

    public init(_ closure: @escaping Closure) {
        self._closure = closure
    }

    func callAsFunction(_ state: inout State, _ action: Action) {
        _closure(&state, action)
    }
}
