//
//  PlacesCatalogCoordinator.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 20.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import RxSwift

class PlacesCatalogCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        // Инициализация
        let viewModel = PlacesCatalogViewModel()
        let viewController = PlacesCatalogViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        // Для примера - обработчик выбора ресторана,
        // можно вызвать переход на другой View например
        viewModel.selectedItem.asObservable()
            .subscribe(onNext: {
                print("Selected place: \($0.name ?? "?")") })
            .disposed(by: disposeBag)
        
        // Переход на View для выбора текущей библиотеки
        viewModel.showLoadersList.asObservable()
            .flatMap { [weak self] _ -> Observable<LoaderLibrary?> in
                guard let `self` = self else { return .empty() }
                return self.showLoadersList(on: viewController)
            }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: viewModel.setCurrentLoader.asObserver())
            .disposed(by: disposeBag)

        // Обработчик выбоа текущей библиотеки
        _ = viewModel.setCurrentLoader.asObservable()
            .subscribe({
                if let loaderLibrary = $0.element {
                    // Если необходимо - вызывается очистка кеша
                    // текущей (еще не измененной) библиотеки
                    viewModel.clearCache.asObserver().onNext(viewModel.loaderLybrary!)
                    // Смена текущей библиотеки
                    viewModel.loaderLybrary = loaderLibrary
                    // Перезагрузка таблицы
                    viewModel.reload.asObserver().onNext(())
                }
            })
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showLoadersList(on rootViewController: UIViewController) -> Observable<LoaderLibrary?> {
        
        let imageLoadersCoordinator = ImageLoadersCoordinator(rootViewController: rootViewController)
        return coordinate(to: imageLoadersCoordinator)
            .map { result in
                switch result {
                case .loader(let loader): return loader
                case .cancel: return nil
                }
        }
        
    }
    
}
