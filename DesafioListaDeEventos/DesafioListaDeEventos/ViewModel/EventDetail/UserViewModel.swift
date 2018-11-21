//
//  UserViewModel.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift

final class UserCollectionViewModel {
    var userVMs: Observable<[UserViewModel]>
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol, users: [User]) {
        self.apiService = apiService
        userVMs = Observable.just(users.map { UserViewModel(apiService: apiService, user: $0) })
    }
}

final class UserViewModel {
    var userImage: Observable<UIImage>
    var userName: Observable<String>
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol, user: User) {
        self.apiService = apiService
        
        userImage = apiService.fetchImage(of: user).share(replay: 1, scope: .forever)
        userName = Observable.just(user.name)
    }
}
