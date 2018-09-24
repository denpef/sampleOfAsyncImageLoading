//
//  ImageLoadersViewModel.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 21.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import RxSwift

class ImageLoadersViewModel {
    
    // MARK: - Inputs
    
    let selectLoader: PublishSubject<LoaderLibrary>
    let cancel: PublishSubject<Void>
    
    // MARK: - Outputs
    
    let loaders: Observable<[LoaderLibrary]>
    
    init() {
        
        self.loaders = Observable.of([
            LoaderLibrary.Kingfisher,
            LoaderLibrary.Nuke_,
            LoaderLibrary.SDWebImage])
        
        self.selectLoader = PublishSubject<LoaderLibrary>()
        self.cancel = PublishSubject<Void>()
    }
}
