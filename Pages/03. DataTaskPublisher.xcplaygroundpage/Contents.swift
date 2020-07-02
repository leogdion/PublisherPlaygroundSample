import SwiftUI
import Combine
import PlaygroundSupport

class ContentObject: ObservableObject {
  @Published var value : Int
  @Published var words = ""
  
  var increment = PassthroughSubject<Void, Never>()
  
  var cancellable : AnyCancellable!
  var wordsCancellable : AnyCancellable!
  
  static let url = URL(string: "https://baconipsum.com/api/?type=all-meat&sentences=1&format=json")!
  
  init () {
    self.value = 12
    
    let urlPublisher = URLSession.shared.dataTaskPublisher(for: ContentObject.url)
    .map(\.data)
    .decode(type: [String].self, decoder: JSONDecoder())
    .replaceError(with: [String]())
    .compactMap{ $0.first }
    
    wordsCancellable = urlPublisher
      .receive(on: DispatchQueue.main)
      .assign(to: \.words, on: self)
    
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
        Text(object.words)
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
