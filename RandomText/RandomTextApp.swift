//
//  RandomTextApp.swift
//  RandomText
//
//  Created by 김종권 on 2022/09/23.
//

import SwiftUI

@main
struct RandomTextApp: App {
  @State var text: String = ""
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.deepLinkText, text)
        .onOpenURL { url in
          text = url.absoluteString.removingPercentEncoding ?? ""
        }
    }
  }
}

struct DeepLinkEnv: EnvironmentKey {
  static let defaultValue = ""
}

extension EnvironmentValues {
  var deepLinkText: String {
    get { self[DeepLinkEnv.self] }
    set { self[DeepLinkEnv.self] = newValue }
  }
}
