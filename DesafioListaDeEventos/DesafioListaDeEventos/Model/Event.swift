//
//  Event.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 12/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation

struct Event: Decodable {
    let id: String
    let title: String
    let price: Double
    let image: String
    let description: String
    let people: [User]
    let date: Double
}
