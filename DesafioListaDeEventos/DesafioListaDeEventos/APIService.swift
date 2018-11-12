//
//  APIService.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 12/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

final class APIService {
    private let manager = SessionManager.default
    private var disposeBag = DisposeBag()
    private let eventsPath = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
    
    func fetchEvents() {
        manager.rx
            .responseData(.get, eventsPath)
            .map { result -> [Event] in
                let (response, data) = result
                do {
                    let events = try JSONDecoder().decode([Event].self, from: data)
                    return events
                } catch {
                    print(error)
                }
                return []
            }.subscribe(onNext: {
                print($0)
            })
    }
}
