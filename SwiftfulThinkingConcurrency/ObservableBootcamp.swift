//
//  ObservableBootcamp.swift
//  SwiftfulThinkingConcurrency
//
//  Created by Pavlo Bezkorovainyi on 11.11.2024.
//

import SwiftUI

actor TitleDatabase {
  
  func getNewTitle() -> String {
    "Some new title"
  }
}

@Observable class ObservableViewModel {
  
  @ObservationIgnored let database = TitleDatabase()
  @MainActor var title: String = "StartingT title"
  
  func updateTitle() async  {
    let title = await database.getNewTitle()
    
    await MainActor.run {
      self.title = title
      print(Thread.current)
    }
    
//    Task { @MainActor in
//      title = await database.getNewTitle()
//    }
  }
}

struct ObservableBootcamp: View {
  
  @State private var viewModel = ObservableViewModel()
  
    var body: some View {
      Text(viewModel.title)
        .task {
          await viewModel.updateTitle()
        }
    }
}

#Preview {
    ObservableBootcamp()
}
