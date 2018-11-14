//
//  EventDetailViewController.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 13/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

// The variant sizes the header view can be
private let headerViewDefaultHeight: CGFloat = 300
private let headerViewMinimunHeight: CGFloat = 100
private let headerViewMaxHeight: CGFloat = 400

class EventDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: EventDetailViewModel!
    //var descriptionDataSource: RxTableViewSectionedReloadDataSource<SectionOfDescription>
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(type: EventTableViewCell.self)
        tableView.register(type: UserCollectionTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: headerViewDefaultHeight, left: 0, bottom: 0, right: 0)
        
        tableView.rx
            .contentOffset.asObservable()
            .map { $0.y }
            .subscribe(onNext: { [unowned self] currentY in
                let y = headerViewDefaultHeight - (currentY + headerViewDefaultHeight)
                self.headerViewHeightConstraint.constant = min(max(y, headerViewMinimunHeight), headerViewMaxHeight)
            }).disposed(by: disposeBag)
    }
    
    func bind(to viewModel: EventDetailViewModel) {
        loadViewIfNeeded()
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfDescription>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item {
                case let .eventDescription(eventDescription):
                    let cell: EventTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.textLabel?.text = eventDescription.itemTitle + " " + eventDescription.itemDescription
                    return cell
                    
                case let .userCollection(userCollectionVM):
                    let cell: UserCollectionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.bind(to: userCollectionVM)
                    return cell
                }
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        let descriptionSection = viewModel.eventDescription.map { events in
            return events.map { TableItem.eventDescription($0) }
            }.map { SectionOfDescription(header: "Detalhes do evento", items: $0) }
        
        let userImagesSection = viewModel.userCollectionViewModel
            .map { [TableItem.userCollection($0)] }
            .map { SectionOfDescription(header: "Pessoas", items: $0) }
        
        Observable.zip(descriptionSection, userImagesSection) { [$0, $1] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.eventImage
            .bind(to: headerImageView.rx.image)
            .disposed(by: disposeBag)
    }
}

enum TableItem {
    case eventDescription(EventDescription)
    case userCollection(UserCollectionViewModel)
}

struct SectionOfDescription {
    var header: String
    var items: [Item]
}

extension SectionOfDescription: SectionModelType {
    typealias Item = TableItem
    
    init(original: SectionOfDescription, items: [Item]) {
        self = original
        self.items = items
    }
}
