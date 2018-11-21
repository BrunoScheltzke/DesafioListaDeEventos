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
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(to viewModel: UserViewModel) {
        userImageView.lock()
        
        viewModel.userImage
            .do(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.userImageView.unlock()
            })
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.userName
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
