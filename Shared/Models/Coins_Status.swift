//
//  Coins_Status.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//

import CoreData


class Coins_Status: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count", timestamp
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let timestamp = try container.decode(String.self, forKey: .timestamp)
        self.timestamp = DateFormatter.jsonDateFormater.date(from:timestamp)!
        
        totalCount = try container.decode(Int64.self, forKey: .totalCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(totalCount, forKey: .totalCount)
        
    }
}

extension Coins_Status {
    static let removeAllRequest: NSBatchDeleteRequest = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Status")
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }()
}
