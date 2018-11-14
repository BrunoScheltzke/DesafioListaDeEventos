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

class EventDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private let headerViewDefaultHeight: CGFloat = 210
    
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
