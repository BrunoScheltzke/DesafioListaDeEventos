//
//  EventListViewModel.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 13/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation
import RxSwift

final class EventListViewModel {
    var eventsViewModel: Observable<[EventCellViewModel]>
    var selectRowAt: PublishSubject<Int> = PublishSubject()
    var askToPresent: PublishSubject<Event> = PublishSubject()
    
    private var events: Observable<[Event]>
    private let apiService: APIServiceProtocol
    
    private let disposeBag = DisposeBag()
    
    init(_ apiService: APIServiceProtocol) {
        self.apiService = apiService
        events = apiService.fetchEvents()
            .map({ result -> [Event] in
                if case let .success(events) = result {
                    return events
                } else {
                    return []
                }
            })
        
        eventsViewModel = events.map { $0.map { EventCellViewModel($0) } }
        
        Observable.combineLatest(selectRowAt, events)
            .map { $1[$0] }
            .bind(to: askToPresent)
            .disposed(by: disposeBag)
    }
}
