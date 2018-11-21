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
    
    @IBOutlet weak var checkInButton: UIButton!
    
    var viewModel: EventDetailViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupShareButton()
    }
    
    func setupShareButton() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(shareEvent))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc func shareEvent() {
        let activityViewController = UIActivityViewController(activityItems: [viewModel.eventShareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(type: EventDetailTableViewCell.self)
        tableView.register(type: UserCollectionTableViewCell.self)
        tableView.register(type: MapTableViewCell.self)
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
        self.viewModel = viewModel
        
        bindTableView()
        bindHeaderImage()
        bindCheckInButton()
    }
    
    func bindTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfDescription>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch item {
                case let .eventDescription(eventDescription):
                    let cell: EventDetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.textLabel?.text = eventDescription.itemDescription
                    return cell
                    
                case let .userCollection(userCollectionVM):
                    let cell: UserCollectionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.bind(to: userCollectionVM)
                    return cell
                case let .map(position):
                    let cell: MapTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                    let (latitude, longitude) = position
                    
                    if let latitude = latitude,
                        let longitude = longitude {
                        cell.setMap(latitude: latitude, longitude: longitude)
                    }
                    
                    return cell
                }
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        let descriptionSection = viewModel.eventDescription.map { events in
            return events.map { TableItem.eventDescription($0) }
            }.map { SectionOfDescription(header: "Detalhes do evento", items: $0) }
        
        let mapSection = viewModel.location
            .map { [TableItem.map($0)] }
            .map { SectionOfDescription(header: "Mapa", items: $0) }
        
        let userImagesSection = viewModel.userCollectionViewModel
            .map { [TableItem.userCollection($0)] }
            .map { SectionOfDescription(header: "Pessoas", items: $0) }
        
        Observable.zip(descriptionSection, mapSection, userImagesSection) { [$0, $1, $2] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindHeaderImage() {
        headerImageView.lock()
        viewModel.eventImage
            .do(onNext: { [unowned self] _ in
                self.headerImageView.unlock()
            })
            .bind(to: headerImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    func bindCheckInButton() {
        checkInButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in self.askForCheckInDetails() })
            .disposed(by: disposeBag)
    }
    
    func askForCheckInDetails() {
        let alertController = UIAlertController(title: "CheckIn", message: "Preencha seus detalhes", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Nome"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Email"
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let checkInAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in
            guard let nameTextField = alertController.textFields?[0],
                let emailTextField = alertController.textFields?[1],
                let name = nameTextField.text,
                let email = emailTextField.text,
                !name.isEmpty,
                !email.isEmpty else {
                    self.present(alertController, animated: true, completion: nil)
                    return
            }
            self.view.lock()
            self.viewModel.checkInAction.execute((name, email))
                .subscribe(onNext: { [unowned self] _ in
                    self.view.unlock()
                    self.present(message: "Sucesso")
                }, onError: { error in
                    self.view.unlock()
                    self.present(error: error)
                }).disposed(by: self.disposeBag)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(checkInAction)
        present(alertController, animated: true, completion: nil)
    }
}

enum TableItem {
    case eventDescription(EventDescription)
    case userCollection(UserCollectionViewModel)
    case map((latitude: Double?, longitude: Double?))
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
