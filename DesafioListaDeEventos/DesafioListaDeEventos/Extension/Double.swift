//
//  Double.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation

extension Double {
    func toBrazilianCurrency() -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "pt_BR")
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber)
    }
}
