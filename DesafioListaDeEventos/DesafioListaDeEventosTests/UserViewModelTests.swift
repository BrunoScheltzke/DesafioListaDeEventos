//
//  UserViewModelTests.swift
//  DesafioListaDeEventosTests
//
//  Created by Bruno Fontenele Scheltzke on 21/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import RxBlocking
import XCTest
@testable import DesafioListaDeEventos

class UserViewModelTests: XCTestCase {
    private var apiService: APIServiceProtocol!
    private var viewModel: UserViewModel!
    
    override func setUp() {
        apiService = MockAPIService()
        
        let user = User.init(id: "1", name: "James", picture: "userPlaceholder")
        
        viewModel = UserViewModel(apiService: apiService, user: user)
    }
    
    func testGetEventImage() {
        do {
            guard let image = try viewModel.userImage.toBlocking().first() else {
                XCTFail("Should return the image of event")
                return
            }
            let placeholderImage: UIImage = #imageLiteral(resourceName: "userPlaceholder")
            XCTAssert(image == placeholderImage, "The mock implementation returns placeholder image")
        } catch {
            XCTFail("Should return the placeholder image")
        }
    }
}
