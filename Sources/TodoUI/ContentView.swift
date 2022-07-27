
import CRDTKit
import SwiftUI

struct Todo: Codable, Identifiable {
    var id = UUID()
    var done: Bool = false
    var title: String
}

struct TodoList: View {
    @Binding var model: LinearSequence<Todo>
    @State var newItem = ""

    var body: some View {
        VStack {
            TextField("New Item", text: $newItem)
                .onSubmit {
                    add()
                }
            List(model.elements) { todo in
                HStack {
                    Toggle("Done", isOn: .constant(todo.done))
                        .toggleStyle(.checkbox)
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
