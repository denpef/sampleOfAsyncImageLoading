//
//  KingfisherManager.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 23.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import Kingfisher

class KingfisherManager: LoaderProtocol {
    
    // Очистка кеша
    static func cleanAllImageCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
        ImageCache.default.cleanExpiredDiskCache()
    }
}

