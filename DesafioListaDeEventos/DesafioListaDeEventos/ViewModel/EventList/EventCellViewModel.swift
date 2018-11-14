//
//  EventCellViewModel.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 13/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation
import RxSwift

final class EventCellViewModel {
    let title: Observable<String>
    
    init(_ event: Event) {
        title = Observable.just(event.title)
    }
}
