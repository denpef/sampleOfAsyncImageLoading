//
//  SDWebLoaderManager.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 23.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import SDWebImage

class SDWebLoaderManager: LoaderProtocol {
    
    static func cleanAllImageCache() {
        SDWebImageManager.shared().imageCache?.clearMemory()
        SDWebImageManager.shared().imageCache?.clearDisk(onCompletion: nil)
    }
    
}
