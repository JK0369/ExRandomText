//
//  ContentView.swift
//  RandomText
//
//  Created by 김종권 on 2022/09/23.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.deepLinkText) var deepLinkText: String
  
  var body: some View {
    if deepLinkText.isEmpty {
      Text("Hello World")
    } else {
      Text(deepLinkText)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct TextModel: Codable {
  enum CodingKeys : String, CodingKey {
    case datas = "data"
  }
  let datas: [String]
}
