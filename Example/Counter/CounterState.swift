//
//  CounterState.swift
//  Example
//
//  Created by Boska on 2020/8/6.
//

import Rebine
import Combine
import SwiftUI

struct CounterState: StateManageable {
    var value: Int
    var isLoadingNumber = false
    var isConnectedToTimer = false

    enum Action {
        case increment
        case decrement
        case loadNumber
        case numberDidLoad(Int)
        case toggleTimer
    }

    static var initialState: CounterState {
        .init(value: 0)
    }

    static var reducer: Reducer<CounterState, Action> {
        .init { state, action in
            switch action {
            case .increment:
                state.value += 1

            case .decrement:
                state.value -= 1

            case .numberDidLoad(let newValue):
                state.value = newValue
                state.isLoadingNumber = false

            case .loadNumber:
                state.isLoadingNumber = true

            case .toggleTimer:
                state.isConnectedToTimer.toggle()
                state.value = 0
            }
        }
    }

    static var feedback: Feedback<CounterState, Action> {
        .init { states in
            let loadNumber = states
                .map(\.isLoadingNumber)
                .removeDuplicates()
                .filter { $0 }
                .map { _ -> AnyPublisher<Action, Never> in
                    Just(.numberDidLoad(Int.random(in: 1...100)))
                        .delay(for: 2.0, scheduler: DispatchQueue.main)
                        .print("🎲")
                        .eraseToAnyPublisher()
                }
                .switchToLatest()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()



            let timerPublisher: () -> AnyPublisher<Action, Never> = {
                Timer.publish(every: 1.0, on: RunLoop.main, in: .default)
                    .autoconnect()
                    .map { _ in .increment }
                    .print("⏱")
                    .eraseToAnyPublisher()
            }

            let timer = states
                .map(\.isConnectedToTimer)
                .removeDuplicates()
                .map { $0 ? timerPublisher() : Empty().eraseToAnyPublisher() }
                .switchToLatest()
                .eraseToAnyPublisher()

            return Publishers.MergeMany([
                loadNumber,
                timer
            ])
            .eraseToAnyPublisher()
        }
    }

}
