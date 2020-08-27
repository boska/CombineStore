//
//  CounterState.swift
//  Example
//
//  Created by Yang Lee on 2020/8/6.
//

import Combine
import CombineExt
import CombineStore
import SwiftUI

struct CounterState: StoreManageable {
    var value = 0
    var isLoadingNumber = false
    var isConnectedToTimer = false

    enum Action {
        case increment
        case decrement
        case loadNumber
        case numberDidLoad(Int)
        case toggleTimer
    }

    static let initialState = CounterState()

    static func reducer(_ state: inout CounterState, _ action: Action) {
        switch action {
        case .increment:
            state.value += 1

        case .decrement:
            state.value -= 1

        case let .numberDidLoad(newValue):
            state.value = newValue
            state.isLoadingNumber = false

        case .loadNumber:
            state.isLoadingNumber = true

        case .toggleTimer:
            state.isConnectedToTimer.toggle()
            state.value = 0
        }
    }

    static var feedback: Feedback<CounterState> {
        .merge([
            loadNumber,
            timer,
        ])
    }

    private static var loadNumber: Feedback<CounterState> {
        .scope(on: \.isLoadingNumber) {
            $0
                .filter { $0 }
                .map { _ -> AnyPublisher<Action, Never> in
                    Just(.numberDidLoad(Int.random(in: 1 ... 100)))
                        .delay(for: 0.5, scheduler: DispatchQueue.main)
                        .print("🎲")
                        .eraseToAnyPublisher()
                }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }

    private static var timer: Feedback<CounterState> {
        .scope(on: \.isConnectedToTimer) { states in
            states
                .map { $0 ? timerPublisher : Empty().eraseToAnyPublisher() }
                .switchToLatest()
                .eraseToAnyPublisher()
        }
    }

    private static var timerPublisher: AnyPublisher<Action, Never> {
        Timer.publish(every: 1.0, on: RunLoop.main, in: .default)
            .autoconnect()
            .map { _ in .increment }
            .print("⏱")
            .eraseToAnyPublisher()
    }
}
