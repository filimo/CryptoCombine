//
//  Item.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 6.05.21.
//

import CoreData
import Foundation
import SwiftUI

class Item: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case timestamp
    }
    
    static var context: NSManagedObjectContext {
        PersistenceController.shared.viewContext
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init(context: Self.context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(timestamp, forKey: .timestamp)
    }
}

extension Item {
    static func fetchRequestLimit(fetchLimit: Int) -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let allElementsCount = (try? context.count(for: request)) ?? 0
        
//        request.fetchOffset = allElementsCount - fetchLimit
        request.fetchLimit = fetchLimit
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)]
        
        return request
    }
}
