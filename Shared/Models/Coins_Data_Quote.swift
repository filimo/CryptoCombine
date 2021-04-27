//
//  Coins_Data_Quote.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//

import CoreData

class Coins_Data_Quote: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case BTC
        case USD
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.contains(.BTC) {
            self.info = try container.decode(Coins_Data_Quote_Info.self, forKey: .BTC)
        }
        if container.contains(.USD) {
            self.info = try container.decode(Coins_Data_Quote_Info.self, forKey: .USD)
        }
    }
}
