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
            Text("\(state.value)")
                .font(.largeTitle)
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
                                .stroke(lineWidth: 3)
                        )
                }
                .foregroundColor(state.isLoadingNumber ? Color.green : Color.red)

                Button(action: { dispatch(.toggleTimer) }) {
                    Image(systemName: "timer")
                        .font(Font.system(.largeTitle))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 3)
                        )
                }
                .foregroundColor(state.isConnectedToTimer ? Color.green : Color.red)
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
