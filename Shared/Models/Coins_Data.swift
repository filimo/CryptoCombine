//
//  Coins_Data.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//

import CoreData

class Coins_Data: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, name, symbol, slug

        case quote
    }

    enum Quote: CodingKey {
        case USD, BTC
    }
    
    var ID: String {
        "\(coinID)-\(id)"
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.slug = try container.decode(String.self, forKey: .slug)

        let quoteContainer = try container.nestedContainer(keyedBy: Quote.self, forKey: .quote)

        if let quote = try? quoteContainer.decode(Coins_Data_Quote.self, forKey: .USD) {
            quote.id = id
            quote.convert = "USD"
            self.quote = quote
        } else if let quote = try? quoteContainer.decode(Coins_Data_Quote.self, forKey: .BTC) {
            quote.id = id
            quote.convert = "BTC"
            self.quote = quote
        }
    }
}

extension Coins_Data {
    static func fetchRequestLimit(fetchLimit: Int) -> NSFetchRequest<Coins_Data> {
        let request: NSFetchRequest<Coins_Data> = Coins_Data.fetchRequest()
        
        request.fetchLimit = fetchLimit
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Coins_Data.coinID, ascending: false)]
        
        return request
    }
}
