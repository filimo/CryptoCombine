//
//  ContentView.swift
//  Shared
//
//  Created by Viktor Kushnerov on 22.04.21.
//

import CoreData
import SwiftUI

struct CloudKitView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var store = Store.shared

    @FetchRequest(entity: Coins_Data_Quote_Info.entity(), sortDescriptors: [])
    private var items: FetchedResults<Coins_Data_Quote_Info>

    var body: some View {
        VStack {
            HStack {
                Button("Refresh") {
                    store.requestToCoinMarketCap()
                }
                Button("Clear") {
                    store.removeAllCoins()
                }
            }

            List {
                ForEach(items, id: \.id) { item in
//                Text("Item at \(item.timestamp ?? Date(), formatter: itemFormatter)")
                    HStack {
                        Text(item.id ?? "")
                        Text(item.quote?.data?.name ?? "")
                        Text(item.convert ?? "")
                        Text("\(item.price)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                #if os(iOS)
                EditButton()
                #endif

                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct CloudKitView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
