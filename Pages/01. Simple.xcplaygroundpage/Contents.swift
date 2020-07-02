import SwiftUI
import Combine
import PlaygroundSupport

class ContentObject: ObservableObject {
  @Published var value : Int

  var cancellable : AnyCancellable!
  init () {
    self.value = 12
  }
}

struct ContentView: View {
  @EnvironmentObject var object : ContentObject
  
    var body: some View {
      VStack{
        Spacer()
        Text(object.value.description)
        Spacer()
      }
    }
}

PlaygroundPage.current.setLiveView(ContentView().environmentObject(ContentObject()))
