//
//  BaseCoordinator.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 20.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import RxSwift

/// Базовый generic класс для реализации coordinators и осуществления навигации между view
class BaseCoordinator<ResultType> {
    
    typealias CoordinationResult = ResultType
    
    let disposeBag = DisposeBag()
    
    /// Уникальный идентификатор
    private let identifier = UUID()
    
    /// Словарь дочерних координаторов. Необходимо добавить каждого дочернего
    /// координатора в этот словарь, чтобы сохранить его в памяти.
    /// Ключ - это «идентификатор» дочернего координатора, а значение - сам координатор.
    /// Тип значения - `Any`, потому что Swift не позволяет хранить общие типы в массиве.
    private var childCoordinators = [UUID: Any]()
    
    /// Хранилище для `childCoordinators`
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    /// Удаляет координатор из `childCoordinators`.
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    /// 1. Добавляет дочерний координатор в словарь
    /// 2. Вызывает метод `start()` этого coordinator.
    /// 3. По событию `onNext:` возвращаемого observable метода `start()` удаляет coordinator из хранилища
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }
    
    /// Начало работы coordinator
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
