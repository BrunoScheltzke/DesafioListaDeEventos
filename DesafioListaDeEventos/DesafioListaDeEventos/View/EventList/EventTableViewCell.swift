//
//  EventTableViewCell.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 13/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift

class EventTableViewCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
    }
    
    func bindTo(_ viewModel: EventCellViewModel) {
        viewModel.title
            .bind(to: textLabel!.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
