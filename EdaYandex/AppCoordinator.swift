//
//  AppCoordinator.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 20.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        var coordinator: BaseCoordinator<Void>
        
        // Выбор стартового coordinator
        coordinator = PlacesCatalogCoordinator(window: window)
        
        return coordinate(to: coordinator)
        
    }
    
}
