//
//  GlobalActorBootcamp.swift
//  SwiftfulThinkingConcurrency
//
//  Created by Павел Бескоровайный on 28.03.2024.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor {
  
  static var shared = MyNewDataManager()
  
}

actor MyNewDataManager {
  
  func getDataFromDatabase() -> [String] {
    return ["One", "Two", "Three", "Four", "Five"]
  }
  
}

@MainActor
class GlobalActorBootcampViewModel: ObservableObject {
  
  @MainActor @Published var dataArray: [String] = []
  let manager = MyFirstGlobalActor.shared
  
//  @MyFirstGlobalActor 
  @MainActor
  func getData() {
    
    //HEAVY COMPLEX METHODS
    Task {
      let data = await manager.getDataFromDatabase()
      self.dataArray = data
    }
  }
}

struct GlobalActorBootcamp: View {
  
  @StateObject private var viewModel = GlobalActorBootcampViewModel()
  
  var body: some View {
    ScrollView {
      VStack {
        ForEach(viewModel.dataArray, id: \.self) {
          Text($0)
            .font(.headline)
        }
      }
    }
    .task {
      viewModel.getData()
    }
  }
}

#Preview {
  GlobalActorBootcamp()
}
