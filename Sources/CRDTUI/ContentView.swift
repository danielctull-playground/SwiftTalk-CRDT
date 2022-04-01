
import CRDTKit
import Multipeer
import SwiftUI

public struct ContentView: View {
    public init() {}

    @State private var int = GrowOnlyCounter(0)
    @State private var online = true

    public var body: some View {
        VStack {
            if online {
                SessionView(counter: $int)
            }
            Text("\(int.value)")
            Button("Increment") { int += 1 }
        }
        .fixedSize()
        .padding()
        .toolbar {
            Toggle("Online", isOn: $online)
        }
    }
}

struct SessionView: View {

    @StateObject private var session = MultipeerSession<GrowOnlyCounter<Int>>()
    @Binding var counter: GrowOnlyCounter<Int>

    var body: some View {
        Circle()
            .frame(width: 20, height: 20)
            .foregroundColor(session.connected ? .green : .red)
            .onChange(of: counter) { newValue in
                try! session.send(newValue)
            }
            .onChange(of: session.connected) { _ in
                try! session.send(counter)
            }
            .task {
                for await newValue in session.receiveStream {
                    counter.merge(newValue)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
