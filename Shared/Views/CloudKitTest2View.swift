//
//  ContentView.swift
//  Shared
//
//  Created by Viktor Kushnerov on 22.04.21.
//

import CoreData
import SwiftUI

struct CloudKitTest2View: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var store = Store.shared

    @FetchRequest(fetchRequest: Coins.fetchRequestLimit(fetchLimit: 2))
    private var items: FetchedResults<Coins>
    
    var coins: [Coins_Data] {
        let result = items
//            .suffix(2)
            .flatMap { $0.data as? Set<Coins_Data> ?? Set<Coins_Data>() }
        
        print(result.count, items.count)
        
        return result
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Refresh") {
                    store.requestToCoinMarketCap()
                }
                Button("Clear") {
                    let fetch: NSFetchRequest<NSFetchRequestResult> = Coins.fetchRequest()

                    PersistenceController.shared.batchDelete(fetch: fetch)
                }
            }

            List {
                ForEach(coins, id: \.self) { item in
//                Text("Item at \(item.timestamp ?? Date(), formatter: itemFormatter)")
                    HStack {
                        Text("\(item.id)")
                        Text(item.name ?? "")
                        Text(item.quote?.convert ?? "")
                        Text("\(item.quote?.price ?? 0)")
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

struct CloudKitTest2View_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitTest2View().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
