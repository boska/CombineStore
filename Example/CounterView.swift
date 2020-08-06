//
//  CounterView.swift
//  RebineExample
//
//  Created by Yang on 2020/8/2.
//

import SwiftUI
import Rebine
import Combine

enum Counter: RebineCompatible {
    struct State {
        var value: Int
        var isLoadingNumber = false
        var isConnectedToTimer = false
    }

    enum Action {
        case increment
        case decrement
        case loadNumber
        case numberDidLoad(Int)
        case toggleTimer
    }

    static let initialValue = State(value: 0)

    static let reducer = Reducer<State, Action> { state, action in
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


    static let feedback = Feedback<State, Action> { states in
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

struct CounterView: View {
    @StateObject var store = Store<Counter.State, Counter.Action>(Counter.self)
    @State var state = Counter.State(value: 0)
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Text("\(state.value)")

            HStack {
                Button(action: { store.dispatch(.increment)}) {
                    Image(systemName: "plus.square.fill")
                }

                Button(action: { store.dispatch(.decrement) }) {
                    Image(systemName: "minus.square.fill")
                }
            }

            HStack {
                Button(action: { store.dispatch(.loadNumber)  }) {
                    Image(systemName: "questionmark.square.fill")
                }
                .foregroundColor(state.isLoadingNumber ? Color.green : Color.blue)

                Button(action: { store.dispatch(.toggleTimer) }) {
                    Image(systemName: "arrow.right.arrow.left.square.fill")
                }
                .foregroundColor(state.isConnectedToTimer ? Color.red : Color.blue)
            }
        }
        .font(.system(size: 100))
        .frame(width: 300)
        .onReceive(store.statePublisher) {
            state = $0
        }

    }

}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
