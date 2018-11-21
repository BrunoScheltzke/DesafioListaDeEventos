//
//  EventDetailViewModel.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 13/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct EventDescription {
    let itemTitle: String
    let itemDescription: String
}

final class EventDetailViewModel {
    let eventDescription: Observable<[EventDescription]>
    let eventImage: Observable<UIImage>
    let userCollectionViewModel: Observable<UserCollectionViewModel>
    
    let checkInAction: Action<(name: String, email: String), Void>
    
    private let apiService: APIServiceProtocol
    private let event: Observable<Event>
    
    private let disposeBag = DisposeBag()
    
    init(_ apiService: APIServiceProtocol, event: Event) {
        self.apiService = apiService
        
        //fetch by id instead
        self.event = Observable.just(event)
        eventDescription = self.event.map {
            [
                EventDescription(itemTitle: "", itemDescription: $0.title),
                EventDescription(itemTitle: "Preço", itemDescription: $0.price.toBrazilianCurrency() ?? "\($0.price)"),
                EventDescription(itemTitle: "Detalhes", itemDescription: $0.description)
            ]
        }
        
        eventImage = apiService.fetchImage(of: event)
        userCollectionViewModel = self.event.map { UserCollectionViewModel(apiService: apiService, users: $0.people) }
        
        checkInAction = Action(workFactory: { input in
            apiService.checkIn(event, name: input.name, email: input.email)
        })
    }
}
