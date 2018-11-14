//
//  EventDetailViewModel.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 13/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation
import RxSwift

struct EventDescription {
    let itemTitle: String
    let itemDescription: String
}

final class EventDetailViewModel {
    let eventDescription: Observable<[EventDescription]>
    
    private let apiService: APIServiceProtocol
    private let event: Observable<Event>
    
    init(_ apiService: APIServiceProtocol, event: Observable<Event>) {
        self.apiService = apiService
        
        //fetch by id instead
        self.event = event
        eventDescription = event.map {
            [
                EventDescription(itemTitle: "Title", itemDescription: $0.title),
                EventDescription(itemTitle: "Price", itemDescription: $0.price.toBrazilianCurrency() ?? "\($0.price)"),
                EventDescription(itemTitle: "Description", itemDescription: $0.description)
            ]
        }
    }
}
