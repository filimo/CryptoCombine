//
//  Coins.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 26.04.21.
//

import CoreData

class Coins: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case status
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard
            let managedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext],
            let context = managedObjectContext as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)

        let statusContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try statusContainer.decode(Status.self, forKey: .status)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(status, forKey: .status)
    }
}

extension Coins {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
}
