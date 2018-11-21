//
//  MockApiService.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift

final class MockAPIService: APIServiceProtocol {
    var shouldFailRequest: Bool = false
    
    func fetchEvents() -> Observable<Result<[Event]>> {
        if shouldFailRequest {
            return Observable.just(.failure(CustomError.internetConnection))
        } else {
            let user = User.init(id: "1", name: "James", picture: "userPlaceholder")
            let event = Event.init(id: "1", title: "Title", price: "R$ 12,00", image: "eventPlaceholder", description: "Description", people: [user], date: "12/12/12 12:12", latitude: -30.037878, longitude: -51.2148497)
            return Observable.just(.success([event]))
        }
    }
    
    func checkIn(_ event: Event, name: String, email: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func fetchImage(of event: Event) -> Observable<UIImage> {
        return Observable.just(#imageLiteral(resourceName: "eventPlaceholder"))
    }
    
    func fetchImage(of user: User) -> Observable<UIImage> {
        return Observable.just(#imageLiteral(resourceName: "userPlaceholder"))
    }
}
