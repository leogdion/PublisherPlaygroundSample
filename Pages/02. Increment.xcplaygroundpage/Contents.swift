import SwiftUI
import Combine
import PlaygroundSupport

class ContentObject: ObservableObject {
  @Published var value : Int
  
  var increment = PassthroughSubject<Void, Never>()
  
  var cancellable : AnyCancellable!
  
  init () {
    self.value = 12
    cancellable = increment.receive(on: DispatchQueue.main).sink{
        self.value += 1
    }
  }
}

struct ContentView: View {
  @EnvironmentObject var object : ContentObject  
    var body: some View {
      VStack{
        Spacer()
        Text(object.value.description)
        Button(action: {
          self.object.increment.send(())
        }) {
          Text("Increment")
        }
        Spacer()
      }
    }
}

PlaygroundPage.current.setLiveView(ContentView().environmentObject(ContentObject()))
