//
//  ImageLoadersViewCoordinator.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 21.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import RxSwift

/// Type that defines possible coordination results of the `ImageLoaderCoordinator`.
///
/// - loader: Loader was choosen.
/// - cancel: Cancel button was tapped.
enum ImageLoadersCoordinationResult {
    case loader(LoaderLibrary)
    case cancel
}

class ImageLoadersCoordinator: BaseCoordinator<ImageLoadersCoordinationResult> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewController = ImageLoadersViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let viewModel = ImageLoadersViewModel()
        viewController.viewModel = viewModel
        
        let cancel = viewModel.cancel
            .asObservable()
            .map { CoordinationResult.cancel }
        
        let loader = viewModel.selectLoader
            .asObservable()
            .map { CoordinationResult.loader($0) }
        
        rootViewController.present(navigationController, animated: true)
        
        return Observable.merge(cancel, loader)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}
