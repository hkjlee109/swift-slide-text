import SwiftUI
import SlideText

struct ContentView: View {
    var body: some View {
        VStack() {
            SlideText("Lorem ipsum")
            SlideText("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
            SlideText("Lorem ipsum dolor sit amet, consectetur adipiscing elit", speed: 2)
            SlideText("Lorem ipsum dolor sit amet, consectetur adipiscing elit", pauseDuration: 1)
            SlideText("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
