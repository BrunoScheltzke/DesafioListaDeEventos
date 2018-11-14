//
//  EventListViewModelTests.swift
//  DesafioListaDeEventosTests
//
//  Created by Bruno Fontenele Scheltzke on 14/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//


import RxBlocking
import XCTest
@testable import DesafioListaDeEventos

class EventListViewModelTests: XCTestCase {
    private var apiService: APIServiceProtocol!
    private var viewModel: EventListViewModel!
    
    override func setUp() {
        apiService = MockAPIService()
        viewModel = EventListViewModel(apiService)
    }
    
    func testGetEventList() {
        do {
            guard let events = try viewModel.eventsViewModel.toBlocking().first() else {
                XCTFail("Should return at least one event according to mock")
                return
            }
            XCTAssert(events.count == 1, "The mock implementation returns one event")
        } catch {
            XCTFail("Should return at least one event according to mock")
        }
    }
}

