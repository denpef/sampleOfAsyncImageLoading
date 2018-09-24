//
//  NukeManager.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 23.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Nuke

class NukeManager: LoaderProtocol {
    
    // Очистка кеша
    static func cleanAllImageCache() {
        ImageCache.shared.removeAll()
    }
    
}
