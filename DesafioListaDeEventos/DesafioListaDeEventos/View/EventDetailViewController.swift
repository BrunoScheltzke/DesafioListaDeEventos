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
        tableView.register(type: EventTableViewCell.self)
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
                let cell: EventTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.textLabel?.text = item.itemTitle + " " + item.itemDescription
                return cell
        })
        
        let sections = viewModel.eventDescription.map {
            [SectionOfDescription(header: "Detalhes do evento", items: $0)]
        }
        
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.eventImage
            .bind(to: headerImageView.rx.image)
            .disposed(by: disposeBag)
    }
}

// MARK: Table View
extension EventDetailViewController {
    
    
}

struct SectionOfDescription {
    var header: String
    var items: [Item]
}

extension SectionOfDescription: SectionModelType {
    typealias Item = EventDescription
    
    init(original: SectionOfDescription, items: [Item]) {
        self = original
        self.items = items
    }
}
