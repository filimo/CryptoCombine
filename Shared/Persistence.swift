//
//  Persistence.swift
//  Shared
//
//  Created by Viktor Kushnerov on 22.04.21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        for _ in 0 ..< 10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    let container: NSPersistentCloudKitContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "CryptoCombine")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { [self] _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            self.container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
            self.container.viewContext.automaticallyMergesChangesFromParent = true
        })
    }

    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func reset() {
        container.viewContext.reset()
    }

    func execute(_ request: NSPersistentStoreRequest) {
        do {
            try container.viewContext.execute(request)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func batchDelete(fetch: NSFetchRequest<NSFetchRequestResult>) {
        viewContext.perform {
            do {
                let request = NSBatchDeleteRequest(fetchRequest: fetch)

                request.resultType = .resultTypeObjectIDs

                let result = try viewContext.execute(request) as? NSBatchDeleteResult
                let objIDArray = result?.result as? [NSManagedObjectID]
                let changes = [NSDeletedObjectsKey: objIDArray]

                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable: Any], into: [viewContext])
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func batchUpdate(entity: NSEntityDescription) {
        viewContext.perform {
            do {
                let request = NSBatchUpdateRequest(entity: entity)

                request.resultType = .updatedObjectIDsResultType
                request.propertiesToUpdate = ["timestamp": Date()]

                let result = try viewContext.execute(request) as? NSBatchUpdateResult
                let objectIDArray = result?.result as? [NSManagedObjectID]
                let changes = [NSUpdatedObjectsKey: objectIDArray]

                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable: Any], into: [viewContext])
                
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func batchUpdate2(entity: NSEntityDescription) {
        viewContext.perform {
            do {
                let request = NSBatchUpdateRequest(entity: entity)

                request.resultType = .updatedObjectIDsResultType
                request.propertiesToUpdate = ["timestamp": Date()]

                let result = try viewContext.execute(request) as? NSBatchUpdateResult
                let objectIDArray = result?.result as? [NSManagedObjectID]
                let changes = [NSUpdatedObjectsKey: objectIDArray]

                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable: Any], into: [viewContext])
                
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
