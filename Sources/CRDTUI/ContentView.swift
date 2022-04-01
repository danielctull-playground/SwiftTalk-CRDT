
import CRDTKit
import Multipeer
import SwiftUI

public struct ContentView: View {
    public init() {}
    
    @StateObject private var session = MultipeerSession<Max<Int>>()
    @State private var int = Max(0)

    public var body: some View {
        VStack {
            Stepper("\(int.value)", value: $int.value)
        }
        .onChange(of: int) { newValue in
            try! session.send(newValue)
        }
        .task {
            for await newValue in session.receiveStream {
                int.merge(newValue)
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
