//
//  APIService.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 12/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire

protocol APIServiceProtocol {
    func fetchEvents() -> Observable<Result<[Event]>>
    func checkIn(_ event: Event, name: String, email: String) -> Observable<Void>
    func fetchImage(of event: Event) -> Observable<UIImage>
    func fetchImage(of user: User) -> Observable<UIImage>
}

private let basePath = "http://5b840ba5db24a100142dcd8c.mockapi.io/api"
private let eventsPath = basePath + "/events"
private let checkInPath = basePath + "/checkin"

struct APIKeys {
    static let eventId = "eventId"
    static let name = "name"
    static let email = "email"
}

final class APIService: APIServiceProtocol {
    private let manager = SessionManager.default
    private var disposeBag = DisposeBag()
    
    func fetchEvents() -> Observable<Result<[Event]>> {
        return manager.rx.request(.get, eventsPath)
            .validate()
            .data()
            .observeOn(MainScheduler.instance)
            .map { data -> Result<[Event]> in
                do {
                    let events = try JSONDecoder().decode([Event].self, from: data)
                    return .success(events)
                } catch {
                    return .failure(error)
                }
        }
    }
    
    func checkIn(_ event: Event, name: String, email: String) -> Observable<Void> {
        let params = [
            APIKeys.eventId: event.id,
            APIKeys.name: name,
            APIKeys.email: email
        ]
        
        return manager.rx.request(.post, checkInPath, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .observeOn(MainScheduler.instance)
                .map { _ in () }
    }
    
    func fetchImage(of event: Event) -> Observable<UIImage> {
        return fetchImage(path: event.image)
            .map { $0 ?? #imageLiteral(resourceName: "eventPlaceholder") }
    }
    
    func fetchImage(of user: User) -> Observable<UIImage> {
        return fetchImage(path: user.picture)
            .map { $0 ?? #imageLiteral(resourceName: "userPlaceholder") }
    }
    
    private func fetchImage(path: String) -> Observable<UIImage?> {
        return manager.rx.request(.get, path)
            .validate()
            .data()
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
    }
}
