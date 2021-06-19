//
//  ContentView.swift
//  Shared
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Combine
import CoreData
import SwiftUI

struct CloudKitTestView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var store = Store.shared
    
    @State var id = UUID()

//    @FetchRequest(fetchRequest: Item.fetchRequestLimit(fetchLimit: 2))
//    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
                Button("Remove all") {
                    let fetch: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()

                    PersistenceController.shared.batchDelete(fetch: fetch)
                }
                Button("Update") {
                    PersistenceController.shared.batchUpdate(entity: Item.entity())
                }

                ItemListView()
                    .id(id)
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
            
            id = UUID()
        }
    }
}

struct CloudKitTestView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitTest2View().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
