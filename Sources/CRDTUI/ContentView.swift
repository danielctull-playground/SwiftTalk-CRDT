
import CRDTKit
import Multipeer
import SwiftUI

public struct ContentView: View {
    public init() {}
    
    @StateObject private var session = MultipeerSession<GrowOnlyCounter<Int>>()
    @State private var int = GrowOnlyCounter(0)

    public var body: some View {
        VStack {
            Text("\(int.value)")
            Button("Increment") { int += 1 }
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
