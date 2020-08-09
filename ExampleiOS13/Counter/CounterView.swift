//
//  CounterView.swift
//  CombineStoreExample
//
//  Created by Yang Lee on 2020/8/2.
//

import SwiftUI
import Combine
import CombineStore

struct CounterView: View {
    @EnvironmentObject var store: Store<CounterState>

    var state: CounterState {
        store.state
    }

    func dispatch(_ action: CounterState.Action) {
        store.dispatch(action)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Text("\(state.value)")

            HStack {
                Button(action: { self.dispatch(.increment)}) {
                    Image(systemName: "plus.square.fill")
                }

                Button(action: { self.dispatch(.decrement) }) {
                    Image(systemName: "minus.square.fill")
                }
            }

            HStack {
                Button(action: { self.dispatch(.loadNumber)  }) {
                    Image(systemName: "questionmark.square.fill")
                }
                .foregroundColor(state.isLoadingNumber ? Color.green : Color.blue)

                Button(action: { self.dispatch(.toggleTimer) }) {
                    Image(systemName: "arrow.right.arrow.left.square.fill")
                }
                .foregroundColor(state.isConnectedToTimer ? Color.red : Color.blue)
            }
        }
        .font(.system(size: 100))
        .frame(width: 300)

    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
