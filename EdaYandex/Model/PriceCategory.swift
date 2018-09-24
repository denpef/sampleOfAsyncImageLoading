//
//  PriceCategory.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 24.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

public struct PriceCategory: Codable {
    let name: String?
}

public struct PricesCategories: Codable {
    
    let items : [PriceCategory]?
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.singleValueContainer()
        self.items = try? values.decode([PriceCategory].self)
        
    }
    
}
