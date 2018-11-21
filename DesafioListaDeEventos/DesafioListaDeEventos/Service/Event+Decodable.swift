//
//  Event+Decodable.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 21/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation

extension Event {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case image
        case description
        case people
        case date
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        image = try values.decode(String.self, forKey: .image)
        description = try values.decode(String.self, forKey: .description)
        people = try values.decode([User].self, forKey: .people)
        
        let doublePrice = try values.decode(Double.self, forKey: .price)
        price = doublePrice.toBrazilianCurrency() ?? "R$ \(doublePrice)"
        
        let doubleDate = try values.decode(Double.self, forKey: .date)
        date = doubleDate.toDate()
        
        if let lat = try? values.decode(Double.self, forKey: .latitude) {
            latitude = lat
        } else if let lat = try? values.decode(String.self, forKey: .latitude) {
            latitude = Double(lat)
        } else {
            latitude = nil
        }
        
        if let long = try? values.decode(Double.self, forKey: .longitude) {
            longitude = long
        } else if let long = try? values.decode(String.self, forKey: .longitude) {
            longitude = Double(long)
        } else {
            longitude = nil
        }
    }
}
