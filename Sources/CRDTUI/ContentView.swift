
import Multipeer
import SwiftUI

public struct ContentView: View {
    public init() {}
    
    @StateObject private var session = MultipeerSession<Int>()
    @State private var value = 0

    public var body: some View {
        VStack {
            Stepper("\(value)", value: $value)
        }
        .onChange(of: value) { newValue in
            try! session.send(newValue)
        }
        .task {
            for await newValue in session.receiveStream {
                value = newValue
            }
        }
        .fixedSize()
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
