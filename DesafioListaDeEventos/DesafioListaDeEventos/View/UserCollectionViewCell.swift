//
//  UserCollectionViewCell.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(to viewModel: UserViewModel) {
        viewModel.userImage
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.userName
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
