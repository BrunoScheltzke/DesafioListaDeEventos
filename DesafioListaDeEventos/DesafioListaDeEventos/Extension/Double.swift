//
//  Double.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm"
    return formatter
}()

extension Double {
    func toBrazilianCurrency() -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "pt_BR")
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber)
    }
    
    func toDate() -> String {
        let date = Date(timeIntervalSince1970: self/1000)
        return formatter.string(from: date)
    }
}
