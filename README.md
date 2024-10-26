# 🚀 CombineStore: Supercharge Your SwiftUI Apps! 🦸‍♀️

Hey there, awesome developer! 👋 Welcome to CombineStore, the coolest way to manage state in your SwiftUI apps using the power of Combine! 🎉

## 🌟 What's CombineStore?

CombineStore is like a magical 🧙‍♂️ toolbox for your Swift apps. It helps you keep your app's state neat and tidy, making your life easier and your code more awesome!

## 🔥 Features

- 🧘‍♀️ Zen-like state management
- 🔄 Reactive updates with Combine
- 🎭 Action-based state mutations
- 🧪 Easy testing (because who doesn't love writing tests? 😉)

## 🚀 Getting Started

First things first, let's add some CombineStore magic to your project! ✨

### Installation

#### Swift Package Manager

Add the following URL to your project's Swift Package Manager dependencies:

```swift
https://github.com/boska/CombineStore.git
```

## 📚 How to Use

1. **Define Your State**

   ```swift
   struct AppState {
       var counter: Int = 0
       var username: String = ""
   }
   ```

2. **Create Actions**

   ```swift
   enum AppAction {
       case incrementCounter
       case setUsername(String)
   }
   ```

3. **Implement Your Store**

   ```swift
   final class AppStore: CombineStore<AppState, AppAction> {
       override func reduce(_ state: AppState, _ action: AppAction) -> AppState {
           var newState = state
           switch action {
           case .incrementCounter:
               newState.counter += 1
           case .setUsername(let name):
               newState.username = name
           }
           return newState
       }
   }
   ```

4. **Use in SwiftUI**

   ```swift
   struct ContentView: View {
       @StateObject private var store = AppStore(initialState: AppState())
       
       var body: some View {
           VStack {
               Text("Counter: \(store.state.counter)")
               Button("Increment") {
                   store.dispatch(.incrementCounter)
               }
           }
       }
   }
   ```

## 🤝 Contributing

We love contributions! If you have any ideas, just open an issue and tell us what you think.

## 📄 License

CombineStore is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## 🙏 Acknowledgements

- Thanks to the Swift and SwiftUI teams for their awesome work!
- Shoutout to the Combine framework for making reactive programming a breeze!

---

Made with ❤️ by [Yang Lee, STRV]

Happy coding! 🚀👨‍💻👩‍💻
