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
    var events: Observable<[EventCellViewModel]>
    
    private let apiService: APIServiceProtocol
    
    init(_ apiService: APIServiceProtocol) {
        self.apiService = apiService
        events = apiService.fetchEvents()
            .map({ result -> [EventCellViewModel] in
                if case let .success(events) = result {
                    return events.map { EventCellViewModel($0) }
                } else {
                    return []
                }
            })
    }
}
