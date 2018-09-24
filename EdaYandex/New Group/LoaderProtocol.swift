//
//  LoaderProtocol.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 23.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

//import UIKit

// Для очистки кеша так как методы пересекаются сделано разделение
// библиотек загрузки изображений по файлам, объединенных протоколом
protocol LoaderProtocol: class  {
    static func cleanAllImageCache() -> Void
}
