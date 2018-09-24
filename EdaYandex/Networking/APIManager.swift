//
//  APIManager.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 20.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum NetworkError: Error {
    case server
    case badResponse
    case badCredentials
    case badRequest
}

public enum RequestStatus {
    case none
    case error(NetworkError)
    case success
}

protocol APIManagerProtocol  {
    func getPlaces() -> Single<[Place]>
}

public class APIManager: APIManagerProtocol {
    
    static let shared = APIManager()
    
    func getPlaces() -> Single<[Place]> {
        return PlacesCatalogProvider.rx.request(.catalog)
            .map(Places.self)
            .observeOn(MainScheduler.instance)
            .flatMap({ places -> Single<[Place]> in
                guard let items = places.items else { return Single.just([]) }
                return Single.just(items)
            })
    }
    
}
