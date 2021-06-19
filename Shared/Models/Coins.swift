//
//  Coins.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//

import CoreData

class Coins: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case status, data
    }
    
    var allData: Set<Coins_Data> {
        self.data as? Set<Coins_Data> ?? Set<Coins_Data>()
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init(context: PersistenceController.shared.viewContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try container.decode(Coins_Status.self, forKey: .status)
        status?.coinID = Int64(id.hashValue)
        
        let data = try container.decode(Set<Coins_Data>.self, forKey: .data)
        for item in data {
            item.coinID = Int64(id.hashValue)
            item.quote?.coinID = Int64(id.hashValue)
        }
        self.data = data as NSSet
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(status, forKey: .status)
    }
}

extension Coins {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    static let deleteAllRequest: NSBatchDeleteRequest = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Coins")
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }()
}

extension Coins {
    static func fetchRequestLimit(fetchLimit: Int) -> NSFetchRequest<Coins> {
        let request: NSFetchRequest<Coins> = Coins.fetchRequest()
        
        request.fetchLimit = fetchLimit
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Coins.status?.timestamp, ascending: false)]
        
        return request
    }
}
