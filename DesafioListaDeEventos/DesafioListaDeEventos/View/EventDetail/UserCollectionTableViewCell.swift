//
//  UserCollectionTableViewCell.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class UserCollectionTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        collectionView.register(type: UserCollectionViewCell.self)
    }
    
    func bind(to viewModel: UserCollectionViewModel) {
        collectionView.dataSource = nil
        viewModel.userVMs
            .bind(to: collectionView.rx.items(cellIdentifier: UserCollectionViewCell.reuseIdentifier)) { _, vm, cell in
                guard let cell = cell as? UserCollectionViewCell else { return }
                cell.bind(to: vm)
        }.disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
