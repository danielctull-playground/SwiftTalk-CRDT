
import SwiftUI

struct Todo: Codable, Identifiable {
    var id = UUID()
    var done: Bool = false
    var title: String
}

struct TodoList: View {
    @Binding var model: [Todo]
    @State var newItem = ""

    var body: some View {
        VStack {
            TextField("New Item", text: $newItem)
                .onSubmit {
                    add()
                }
            List($model) { $todo in
                HStack {
                    Toggle("Done", isOn: $todo.done)
                        .toggleStyle(.checkbox)
                    TextField("Title", text: $todo.title)
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

public struct ContentView: View {
    public init() {}
    @State var model: [Todo] = []
    public var body: some View {
        TodoList(model: $model)
    }
}
