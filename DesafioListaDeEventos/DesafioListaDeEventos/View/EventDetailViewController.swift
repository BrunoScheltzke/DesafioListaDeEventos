//
//  EventDetailViewController.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 13/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: EventDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindToViewModel()
    }
    
    func setupTableView() {
        tableView.register(type: UITableViewCell.self)
    }
    
    func bindToViewModel() {
        
    }
}
