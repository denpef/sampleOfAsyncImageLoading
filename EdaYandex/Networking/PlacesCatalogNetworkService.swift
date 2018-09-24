//
//  PlacesCatalogNetworkService.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 20.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import Moya

public var stubJsonPath = ""

public func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

public var PlacesCatalogProvider = MoyaProvider<PlacesCatalogNetworkService>(
    plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)]
)

public enum PlacesCatalogNetworkService {
    case catalog
}

extension PlacesCatalogNetworkService: TargetType {
    
    public var headers: [String : String]? {
        return nil
    }
    
    // Чтобы не усложнять лишнего - все задано как один url
    public var baseURL: URL { return URL(string: "https://eda.yandex/api/v2/catalog?latitude=55.762885&longitude=37.597360")! }
    
    public var path: String {
        
        switch self {
        case .catalog:
            return ""
        }
    }
    public var method: Moya.Method {
        switch self {
        case .catalog:
            return .get
        }
    }
    
    public var sampleData: Data {
        switch self {
        case   .catalog:
            return StubResponse.fromJSONFile(filePath: stubJsonPath)
        }
        
    }
    
    public var task: Task {
        switch self {
        case .catalog:
            return .requestPlain
        }
    }
    
}
