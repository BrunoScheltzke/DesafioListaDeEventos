//
//  EventListViewController.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 13/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class EventListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: EventListViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(type: EventTableViewCell.self)
    }
    
    func bind(to viewModel: EventListViewModel) {
        loadViewIfNeeded()
        self.viewModel = viewModel
        viewModel.eventsViewModel.bind(to: tableView.rx.items(cellIdentifier: EventTableViewCell.reuseIdentifier)) { _, viewModel, cell in
            guard let cell = cell as? EventTableViewCell else { return }
            cell.bindTo(viewModel)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asObservable()
            .map { $0.row }
            .bind(to: viewModel.selectRowAt)
            .disposed(by: disposeBag)
    }
}
