//
//  AppCoordinator.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator {
    var navigationController: UINavigationController
    private let apiService: APIServiceProtocol
    private let window: UIWindow?
    
    private let disposeBag = DisposeBag()
    
    init(_ apiService: APIServiceProtocol, window: UIWindow?) {
        self.window = window
        self.apiService = apiService
        navigationController = UINavigationController()
    }
    
    func start() {
        let viewModel = EventListViewModel(apiService)
        let viewController = EventListViewController()
        viewController.bind(to: viewModel)
        navigationController.viewControllers = [viewController]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        viewModel.askToPresent
            .subscribe(onNext: { [unowned self] event in
                let eventDetailVC = EventDetailViewController()
                let eventDetailVM = EventDetailViewModel(self.apiService, event: Observable.just(event))
                eventDetailVC.bind(to: eventDetailVM)
                self.navigationController.pushViewController(eventDetailVC, animated: true)
            }).disposed(by: disposeBag)
    }
}
