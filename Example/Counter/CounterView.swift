//
//  CounterView.swift
//  CombineStoreExample
//
//  Created by Yang Lee on 2020/8/2.
//

import Combine
import CombineStore
import SwiftUI

struct CounterView: View {
    @StateObject var store = Store<CounterState>()

    var state: CounterState {
        store.state
    }

    func dispatch(_ action: CounterState.Action) {
        store.dispatch(action)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Text("\(state.numberInWords)")
                .font(.title)
                .foregroundColor(Color.white)

            Text("\(state.value)")
                .foregroundColor(Color.white)

            HStack {
                Button(action: { dispatch(.increment) }) {
                    Image(systemName: "plus")
                        .font(Font.system(.largeTitle))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.red, lineWidth: 3)
                        )
                }

                Button(action: { dispatch(.decrement) }) {
                    Image(systemName: "minus")
                        .font(Font.system(.largeTitle))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.red, lineWidth: 3)
                        )
                }
            }

            HStack {
                Button(action: { dispatch(.loadNumber) }) {
                    Image(systemName: "questionmark")
                        .font(Font.system(.largeTitle))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.red, lineWidth: 3)
                        )
                }
                .foregroundColor(state.isLoadingNumber ? Color.green : Color.red)

                Button(action: { dispatch(.toggleLocale) }) {
                    Image(systemName: "network")
                        .font(Font.system(.largeTitle))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.red, lineWidth: 3)
                        )
                }
                .foregroundColor(state.isConnectedToTimer ? Color.red : Color.red)
            }
        }
        .foregroundColor(Color.red)
        .font(.system(size: 100))
        .frame(width: 300)
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
