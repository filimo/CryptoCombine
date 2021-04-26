//
//  Coins_Data.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//

import CoreData

class Coins_Data: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id
        case quote
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int64.self, forKey: .id)
        self.quote = try container.decode(Coins_Data_Quote.self, forKey: .quote)
    }
}
