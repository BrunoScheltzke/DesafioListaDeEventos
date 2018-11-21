//
//  EventDetailViewModel.swift
//  DesafioListaDeEventosTests
//
//  Created by Bruno Fontenele Scheltzke on 21/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import RxBlocking
import XCTest
@testable import DesafioListaDeEventos

class EventDetailViewModelTests: XCTestCase {
    private var apiService: APIServiceProtocol!
    private var viewModel: EventDetailViewModel!
    
    override func setUp() {
        apiService = MockAPIService()
        
        let user = User.init(id: "1", name: "James", picture: "userPlaceholder")
        let event = Event.init(id: "1", title: "Title", price: "R$ 12,00", image: "eventPlaceholder", description: "Description", people: [user], date: "12/12/12 12:12", latitude: -30.037878, longitude: -51.2148497)
        
        viewModel = EventDetailViewModel(apiService, event: event)
    }
    
    func testGetEventDetailInfo() {
        do {
            guard let events = try viewModel.eventDescription.toBlocking().first() else {
                XCTFail("Should return the information related to the event")
                return
            }
            XCTAssert(events.count == 4, "The mock implementation returns the name, price, date and details of the event")
        } catch {
            XCTFail("Should return the name, price, date and details of the event according to mock")
        }
    }
    
    func testGetEventImage() {
        do {
            guard let image = try viewModel.eventImage.toBlocking().first() else {
                XCTFail("Should return the image of event")
                return
            }
            let placeholderImage: UIImage = #imageLiteral(resourceName: "eventPlaceholder")
            XCTAssert(image == placeholderImage, "The mock implementation returns placeholder image")
        } catch {
            XCTFail("Should return the placeholder image")
        }
    }
}
