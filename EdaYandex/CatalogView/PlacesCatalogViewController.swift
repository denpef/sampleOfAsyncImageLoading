//
//  ViewController.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 20.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlacesCatalogViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let clearCacheButtonItem = UIBarButtonItem(title: "Clear cache", style: .done, target: nil, action: nil)
    private let chooseLoaderButton = UIBarButtonItem(title: "Change library", style: .done, target: nil, action: nil)
    
    private let disposeBag = DisposeBag()
    private var refreshControl : UIRefreshControl?
    
    var viewModel: PlacesCatalogViewModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        bindRx()
        
        refreshControl?.sendActions(for: .valueChanged)
        
    }
    
    private func setupUI() {
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationItem.leftBarButtonItem = clearCacheButtonItem
        navigationItem.rightBarButtonItem = chooseLoaderButton
        
        self.refreshControl = UIRefreshControl()
        
        if let refreshControl = self.refreshControl {
            self.tableView.addSubview(refreshControl)
            refreshControl.backgroundColor = .clear
            refreshControl.tintColor = .lightGray
        }
        
    }
    
    private func bindRx() {
        
        viewModel?.places
            .asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.refreshControl?.endRefreshing()
            })
            .filterEmpty()
            .bind(to: tableView.rx.items(cellIdentifier: "PlaceCell",
                                         cellType: PlaceCatalogTableViewCell.self)) { (_, place, cell) in
                                            cell.configure(place: place, loaderLibrary: self.viewModel!.loaderLybrary!)
            }
            .disposed(by: disposeBag)
        
        
        self.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to:self.viewModel!.reload)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: tableView.deselectRow)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Place.self)
            .bind(to: viewModel!.selectedItem)
            .disposed(by: disposeBag)
        
        clearCacheButtonItem.rx.tap
            .map{ self.viewModel!.loaderLybrary! }
            .bind(to: viewModel!.clearCache)
            .disposed(by: disposeBag)
        
        chooseLoaderButton.rx.tap
            .bind(to: viewModel!.showLoadersList)
            .disposed(by: disposeBag)
        
        viewModel!.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel!.alertMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.presentAlert(message: $0)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func presentAlert(message: String) {

        let alertController = UIAlertController(title: "Ошибка. \n Пожалуйста попробуйте повторить запрос", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true)
        
    }
    
}
