//
//  Coins_Data_Quote_Info.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//

import CoreData

class Coins_Data_Quote_Info: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case price, volume24h = "volume_24h"
        case percentChange1h = "percent_change_1h", percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d", percentChange30d = "percent_change_30d"
        case percentChange60d = "percent_change_60d", percentChange90d = "percent_change_90d"
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.price = try container.decode(Double.self, forKey: .price)
        self.volume24h = try container.decode(Double.self, forKey: .volume24h)

        self.percentChange1h = try container.decode(Double.self, forKey: .percentChange1h)
        self.percentChange24h = try container.decode(Double.self, forKey: .percentChange24h)

        self.percentChange7d = try container.decode(Double.self, forKey: .percentChange7d)
        self.percentChange30d = try container.decode(Double.self, forKey: .percentChange30d)
        self.percentChange60d = try container.decode(Double.self, forKey: .percentChange60d)
        self.percentChange90d = try container.decode(Double.self, forKey: .percentChange90d)
    }
}
