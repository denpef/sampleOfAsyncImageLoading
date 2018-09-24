//
//  StubResponse.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 24.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation

class StubResponse {
    static func fromJSONFile(filePath:String) -> Data {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            fatalError("Invalid data from json file")
        }
        return data
    }
}
