//
//  ImageLoadersViewController.swift
//  EdaYandex
//
//  Created by Денис Ефимов on 21.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// View показывает список загрузчиков для выбора библиотеки
class ImageLoadersViewController: UIViewController, StoryboardInitializable {
    
    let disposeBag = DisposeBag()
    var viewModel: ImageLoadersViewModel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Выберите библиотеку"
        
        tableView.rowHeight = 48.0
    }
    
    private func setupBindings() {
        
        viewModel.loaders
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "LoaderCell", cellType: UITableViewCell.self)) { (_, loader, cell) in
                cell.textLabel?.text = loader.rawValue
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(LoaderLibrary.self)
            .bind(to: viewModel.selectLoader)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
    }
}
