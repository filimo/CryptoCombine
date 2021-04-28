//
//  ContentView.swift
//  Shared
//
//  Created by Viktor Kushnerov on 22.04.21.
//

import CoreData
import SwiftUI

struct CloudKitTestView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @ObservedObject var store = Store.shared

    var body: some View {
        NavigationView {
            VStack {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
                Button("Remove all") {
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                    PersistenceController.shared.execute(deleteRequest)
                }
                Button("Update") {
                    let request = NSBatchUpdateRequest(entity: Item.entity())

                    request.propertiesToUpdate = ["timestamp": Date()]

                    PersistenceController.shared.execute(request)
                }

                List {
                    ForEach(items) { item in
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    #if os(iOS)
                    EditButton()
                    #endif
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            PersistenceController.shared.save()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            PersistenceController.shared.save()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct CloudKitTestView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
