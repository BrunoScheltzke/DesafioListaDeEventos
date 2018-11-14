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
    let eventImage: Observable<UIImage>
    let userCollectionViewModel: Observable<UserCollectionViewModel>
    let checkInEvent: PublishSubject<Void> = PublishSubject()
    let checkInButtonIsHidden: Observable<Bool>
    
    private let apiService: APIServiceProtocol
    private let event: Event
    
    private let disposeBag = DisposeBag()
    
    init(_ apiService: APIServiceProtocol, event: Event) {
        self.apiService = apiService
        
        //fetch by id instead
        self.event = event
        eventDescription = Observable.just(
            [
                EventDescription(itemTitle: "Title", itemDescription: event.title),
                EventDescription(itemTitle: "Price", itemDescription: event.price.toBrazilianCurrency() ?? "\(event.price)"),
                EventDescription(itemTitle: "Description", itemDescription: event.description)
            ]
        )
        
        eventImage = apiService.fetchImage(of: event)
        userCollectionViewModel = Observable.just(UserCollectionViewModel(apiService: apiService, users: event.people))
        
        // needs to modify this to check if user has already checked in the event
        checkInButtonIsHidden = Observable.just(true)
        
        checkInEvent
            .subscribe(onNext: { [unowned self] _ in
                self.apiService.checkIn(self.event, name: "Alfredo", email: "alfredo@email.com")
            })
            .disposed(by: disposeBag)
    }
}
