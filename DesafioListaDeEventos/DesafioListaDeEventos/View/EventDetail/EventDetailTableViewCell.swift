//
//  EventDetailTableViewCell.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit

class EventDetailTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
    }
}
