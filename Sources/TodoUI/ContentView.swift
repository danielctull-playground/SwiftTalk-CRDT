
import CRDTKit
import SwiftUI
import MultipeerUI

struct Todo: Equatable, Codable, Identifiable {
    var id = UUID()
    var done: Bool = false
    var title: String
}

struct TodoList: View {
    @Binding var model: LinearSequence<Todo>
    @State var newItem = ""
    @State var online = true

    var body: some View {
        VStack {
            HStack {
                Toggle("Online", isOn: $online)
                if online {
                    SessionView(model: $model)
                }
            }
            TextField("New Item", text: $newItem)
                .onSubmit {
                    add()
                }
            List(model) { todo in
                HStack {
                    Toggle("Done", isOn: .constant(todo.done))
                    TextField("Title", text: .constant(todo.title))
                }
                .labelsHidden()
            }
        }
    }

    func add() {
        let todo = Todo(title: newItem)
        model.insert(todo, at: 0)
    }
}

let site = SiteID()

public struct ContentView: View {
    public init() {}
    @State var model = LinearSequence<Todo>(site: site)
    public var body: some View {
        TodoList(model: $model)
    }
}
