
import CRDTKit
import Foundation
import Multipeer
import SwiftUI

public struct SessionView<M>: View where M: CRDT & Codable & Equatable {

    public init(model: Binding<M>) {
        self._model = model
    }

    @StateObject private var session = MultipeerSession<M>()
    @Binding var model: M

    public var body: some View {
        Circle().frame(width: 20, height: 20)
            .foregroundColor(session.connected ? .green : .red)
            .onChange(of: model) { newValue in
                try! session.send(newValue)
            }
            .onChange(of: session.connected) { _ in
                try! session.send(model)
            }
            .task {
                for await newValue in session.receiveStream {
                    model.merge(newValue)
                }
            }
    }
}
