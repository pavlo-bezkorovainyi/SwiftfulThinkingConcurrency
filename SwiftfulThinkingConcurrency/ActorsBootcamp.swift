//
//  ActorsBootcamp.swift
//  SwiftfulThinkingConcurrency
//
//  Created by Павел Бескоровайный on 28.03.2024.
//

import SwiftUI

// 1. What is the problem that actor are solving/
// 2. How was this problem solved prior to actors?
// 3. Actors can solve them problem!

class MyDataManager {
  
  static let instance = MyDataManager()
  private init() { }
  
  var data: [String] = []
  private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
  
  func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
    lock.async {
      self.data.append(UUID().uuidString)
      print(Thread.current)
      completionHandler(self.data.randomElement())
    }
  }
}

actor MyActorDataManager {
  
  static let instance = MyActorDataManager()
  private init() { }
  
  nonisolated let myRandomText = "Random text"
  
  var data: [String] = []
  
  func getRandomData() -> String? {
    self.data.append(UUID().uuidString)
    print(Thread.current)
    return self.data.randomElement()
  }
  
  nonisolated func getSavedData() -> String { //IMPORTANT! WE CAN USE IT WITHOUT AWAIT
    return "NEW DATA"
  }
  
}



struct HomeView: View {
  
  let manager = MyActorDataManager.instance
  @State private var text: String = ""
  let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.gray.opacity(0.8).ignoresSafeArea()
      
      Text(text)
        .font(.headline)
    }
    .onAppear {
        let newString = manager.getSavedData()
    }
    .onReceive(timer, perform: { _ in
      Task {
        if let data = await manager.getRandomData() {
          await MainActor.run {
            self.text = data
          }
        }
      }
//      DispatchQueue.global(qos: .background).async {
//        manager.getRandomData { title in
//          if let data = title {
//            DispatchQueue.main.async {
//              self.text = data
//            }
//          }
//        }
//      }
    })
    
  }
}

struct BrowseView: View {
  
  let manager = MyActorDataManager.instance
  @State private var text: String = ""
  let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.yellow.opacity(0.8).ignoresSafeArea()
      
      Text(text)
        .font(.headline)
    }
    .onReceive(timer, perform: { _ in
      Task {
        if let data = await manager.getRandomData() {
          await MainActor.run {
            self.text = data
          }
        }
      }

//      DispatchQueue.global(qos: .default).async {
//        manager.getRandomData { title in
//          if let data = title {
//            DispatchQueue.main.async {
//              self.text = data
//            }
//          }
//        }
//      }
    })
  }
}

struct ActorsBootcamp: View {
  var body: some View {
    TabView {
      HomeView()
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }
      
      BrowseView()
        .tabItem {
          Label("Brows", systemImage: "magnifyingglass")
        }
    }
  }
}

#Preview {
  ActorsBootcamp()
}
