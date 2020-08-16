//
//  CounterState.swift
//  Example
//
//  Created by Yang Lee on 2020/8/6.
//

import AVFoundation
import Combine
import CombineExt
import CombineStore
import SwiftUI

struct CounterState: StoreManageable {
    var value = 420
    var isLoadingNumber = false
    var isConnectedToTimer = false
    var locale = Locale(identifier: "cs")
    var numberInWords = "nula"

    enum Action {
        case increment
        case decrement
        case loadNumber
        case numberDidLoad(Int)
        case toggleTimer
        case toggleLocale
        case numberInWordsDidChanged(String)
    }

    static let initialState = CounterState()

    static var reducer: Reducer<CounterState, Action> {
        .init { state, action in
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
            case .toggleLocale:
                state.locale = allLocales.randomElement() ?? .current

            case let .numberInWordsDidChanged(newWords):
                state.numberInWords = newWords
            }
        }
    }

    static var feedback: Feedback<CounterState, Action> {
        .merge([
            loadNumber,
            timer,
            speak,
        ])
    }

    private static var allLocales: [Locale] {
        AVSpeechSynthesisVoice.speechVoices()
            .map(\.language)
            .compactMap { Locale(identifier: $0) }
    }

    private static var speak: Feedback<CounterState, Action> {
        .scope(\.value, \.locale) { state$ in
            let synthesizer = AVSpeechSynthesizer()
            let formatter = NumberFormatter()

            formatter.numberStyle = .spellOut

            return state$
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .map { value, locale in
                    formatter.locale = locale

                    let numberInWords = formatter.string(from: NSNumber(value: value))
                    let utterance = AVSpeechUtterance(string: numberInWords ?? "")

                    utterance.voice = AVSpeechSynthesisVoice(language: locale.identifier)
                    print(locale.identifier)
                    synthesizer.speak(utterance)

                    return .numberInWordsDidChanged(numberInWords ?? "")
                }
                .eraseToAnyPublisher()
        }
    }

    private static var loadNumber: Feedback<CounterState, Action> {
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
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }

    private static var timer: Feedback<CounterState, Action> {
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
