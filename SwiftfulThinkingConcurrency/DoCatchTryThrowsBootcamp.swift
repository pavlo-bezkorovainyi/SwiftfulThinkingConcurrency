//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftfulThinkingConcurrency
//
//  Created by Павел Бескоровайный on 25.03.2024.
//

import SwiftUI

//do-catch
//try
//throws

class DoCatchTryThrowsBootcampDatamanager {
  
  let isActive: Bool = true
  
  func getTitle() -> (title: String?, error: Error?) {
    if isActive {
      return ("NEW TEXT!", nil)
    } else {
      return (nil, URLError(.badURL))
    }
  }
  
  func getTitle2() -> Result<String, Error> {
    if isActive {
      return .success("NEW TEXT!")
    } else {
      return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
    }
  }
  
  func getTitle3() throws -> String {
//    if isActive {
//      return "NEW TEXT!"
//    } else {
      throw URLError(.badServerResponse)
//    }
  }
  
  func getTitle4() throws -> String {
    if isActive {
      return "FINAL TEXT!"
    } else {
      throw URLError(.badServerResponse)
    }
  }
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject {
  
  @Published var text: String = "Starting text."
  let manager = DoCatchTryThrowsBootcampDatamanager()
  
  func fetchTitle() {
    /*
     let returnedValue = manager.getTitle()
     
     if let newTitle = returnedValue.title {
     self.text = newTitle
     } else if let error = returnedValue.error {
     self.text = error.localizedDescription
     }
     */
    
    /*
    let result = manager.getTitle2()
    
    switch result {
    case .success(let newTitle):
      self.text = newTitle
    case .failure(let error):
      self.text = error.localizedDescription
    }
    */
    
//    let newTitle = try? manager.getTitle3()
//    if let newTitle = newTitle {
//      self.text = newTitle
//    }
    
    do {
      let newTitle = try? manager.getTitle3()
      if let newTitle {
        self.text = newTitle
      }
      
      let finalTitle = try manager.getTitle4()
      self.text = finalTitle
    } catch let error {
      self.text = error.localizedDescription
    }
    
  }
}

struct DoCatchTryThrowsBootcamp: View {
  
  @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
  
    var body: some View {
      Text(viewModel.text)
        .frame(width: 300, height: 300)
        .background(Color.blue)
        .onTapGesture {
          viewModel.fetchTitle()
        }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
