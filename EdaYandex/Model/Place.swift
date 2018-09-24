//
//  Place.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 20.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

public struct Picture: Codable {
    
    let uri: String?
    
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

public struct PriceCategory: Codable {
    let name: String?
}

public struct Place: Codable {
    
    let name : String?
    let rating: Float64?
    let picture: Picture?
    let footerDescription: String?
    let deliveryConditions: String?
    let priceCategory: PricesCategories?
    
    enum PlaceLevelCodingKeys: String, CodingKey {
        case place
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rating = "rating"
        case picture = "picture"
        case footerDescription = "footerDescription"
        case deliveryConditions = "deliveryConditions"
        case priceCategory = "priceCategory"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: PlaceLevelCodingKeys.self)
        
        let values = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .place)
        
        name = try values.decodeIfPresent(String.self, forKey: .name)
        rating = try values.decodeIfPresent(Float64.self, forKey: .rating)
        picture = try values.decodeIfPresent(Picture.self, forKey: .picture)
        footerDescription = try values.decodeIfPresent(String.self.self, forKey: .footerDescription)
        deliveryConditions = try values.decodeIfPresent(String.self.self, forKey: .deliveryConditions)
        priceCategory = try values.decodeIfPresent(PricesCategories.self, forKey: .priceCategory)
    }
    
}

public struct Places : Codable {

    let items : [Place]?

    enum PayloadLevelCodingKeys: String, CodingKey {
        case payload
    }
    
    enum FoundPlacesLevelCodingKeys: String, CodingKey {
        case foundPlaces
    }
    
    enum CodingKeys: String, CodingKey {
        case items = "place"
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: PayloadLevelCodingKeys.self)
        
        let payloadContainer = try container.nestedContainer(keyedBy: FoundPlacesLevelCodingKeys.self, forKey: .payload)
                
        self.items = try? payloadContainer.decode([Place].self, forKey: .foundPlaces)

    }

}
