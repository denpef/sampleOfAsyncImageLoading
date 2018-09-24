//
//  PlacesCatalogViewModel.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 20.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

public protocol PlacesCatalogViewModelInputs {
    var clearCache: PublishSubject<LoaderLibrary> { get }
    var title: Observable<String> { get }
    var setCurrentLoader: BehaviorSubject<LoaderLibrary> { get }
    var reload: PublishSubject<Void> { get }
    var alertMessage: Observable<String> { get }
}

public protocol PlacesCatalogViewModelOutputs {
    var places: Observable<[Place]> { get }
    var selectedItem: PublishSubject<Place> { get }
    var showLoadersList: PublishSubject<Void> { get }
    var loaderLybrary: LoaderLibrary? { get }
}

public protocol PlacesCatalogViewModelType {
    var inputs: PlacesCatalogViewModelInputs { get }
    var outputs: PlacesCatalogViewModelOutputs { get }
}

public class PlacesCatalogViewModel: PlacesCatalogViewModelType, PlacesCatalogViewModelInputs, PlacesCatalogViewModelOutputs {
    
    public var loaderLybrary: LoaderLibrary?
    
    private let disposeBag = DisposeBag()
    private let error = PublishSubject<Swift.Error>()
    
    public var selectedItem: PublishSubject<Place>
    public var places: Observable<[Place]>
    public var clearCache = PublishSubject<LoaderLibrary>()
    public var showLoadersList: PublishSubject<Void>
    public var inputs: PlacesCatalogViewModelInputs { return self}
    public var outputs: PlacesCatalogViewModelOutputs { return self}
    public var title: Observable<String>
    public var setCurrentLoader: BehaviorSubject<LoaderLibrary>
    public var reload: PublishSubject<Void>
    public var alertMessage: Observable<String>
    
    init(initialLoader: LoaderLibrary = .SDWebImage) {
        
        self.loaderLybrary = initialLoader
        
        self.selectedItem = PublishSubject<Place>()
        self.reload = PublishSubject<Void>()
        self.setCurrentLoader = BehaviorSubject<LoaderLibrary>(value: initialLoader)
        self.showLoadersList = PublishSubject<Void>()
        
        let _alertMessage = PublishSubject<String>()
        self.alertMessage = _alertMessage.asObservable()
        
        self.title = self.setCurrentLoader.asObservable()
            .map { $0.rawValue }
        
        self.places = self.reload.asObservable()
            .flatMap { _ -> Single<[Place]> in
                return APIManager.shared.getPlaces()
                    .catchError { error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Single.just([])
                }
        }
        
        self.clearCache
            .subscribe(onNext: { [unowned self] loaderLibrary in
                self.flushCache(loaderLibrary: loaderLibrary)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func flushCache(loaderLibrary: LoaderLibrary) {
        
        switch loaderLybrary! {
        case .SDWebImage:
            SDWebLoaderManager.cleanAllImageCache()
        case .Kingfisher:
            KingfisherManager.cleanAllImageCache()
        case .Nuke_:
            NukeManager.cleanAllImageCache()
        }
        
    }
    
}
