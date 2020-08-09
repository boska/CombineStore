//
//  Dispatchable.swift
//  Example
//
//  Created by Yang Lee on 2020/8/9.
//  Copyright © 2020 Yang Lee. All rights reserved.
//

import CombineStore

public protocol Dispatchable {
    associatedtype State: StoreManageable
    var store: Store<State> { get }
}

public extension Dispatchable {
    var state: State {
        store.state
    }

    func dispatch(_ action: State.Action) {
        store.dispatch(action)
    }
}
