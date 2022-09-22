//
//  MyWidget.swift
//  MyWidget
//
//  Created by 김종권 on 2022/09/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), texts: ["Empty"])
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    getTexts { texts in
      let entry = SimpleEntry(date: Date(), texts: texts)
      completion(entry)
    }
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    getTexts { texts in
      let currentDate = Date()
      let entry = SimpleEntry(date: currentDate, texts: texts)
      let nextRefresh = Calendar.current.date(byAdding: .minute, value: 3, to: currentDate)!
      let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
      completion(timeline)
    }
  }
  
  // 메소드 추가
  private func getTexts(completion: @escaping ([String]) -> ()) {
    // https://github.com/wh-iterabb-it/meowfacts
    guard
      let url = URL(string: "https://meowfacts.herokuapp.com/?count=1")
    else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let data = data,
        let textModel = try? JSONDecoder().decode(TextModel.self, from: data)
      else { return }
      completion(textModel.datas)
    }.resume()
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let texts: [String]
}

// 모델 추가
struct TextModel: Codable {
  enum CodingKeys : String, CodingKey {
    case datas = "data"
  }
  let datas: [String]
}

struct MyWidgetEntryView : View {
  var entry: Provider.Entry
  
  private var randomColor: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
  
  var body: some View {
    ZStack {
      randomColor.opacity(0.7)
      ForEach(entry.texts, id: \.hashValue) { text in
        LazyVStack { // Widget은 스크롤이 안되므로, List지원 x (대신 VStack 사용)
          Text(text)
            .foregroundColor(Color.white)
            .lineLimit(1)
          Divider()
        }
      }
    }
  }
}

@main
struct MyWidget: Widget {
  let kind: String = "MyWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      MyWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("위젯 예제")
    .description("랜덤 텍스트를 불러오는 위젯 예제입니다")
  }
}

struct MyWidget_Previews: PreviewProvider {
  static var previews: some View {
    MyWidgetEntryView(entry: SimpleEntry(date: Date(), texts: ["empty"]))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}

