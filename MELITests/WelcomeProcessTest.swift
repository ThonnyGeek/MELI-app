//
//  WelcomeProcessTest.swift
//  MELITests
//
//  Created by Thony Gonzalez on 1/03/24.
//

import XCTest
import Combine

class MockWelcomeServices: WelcomeServicesProtocol{
    func fetchSites() -> AnyPublisher<SitesModel, NetworkErrorHandler> {
        Just([
            SitesModelElement(defaultCurrencyID: "col", id: "1", name: "1"),
            SitesModelElement(defaultCurrencyID: "usd", id: "2", name: "2"),
            SitesModelElement(defaultCurrencyID: "col", id: "3", name: "3"),
            SitesModelElement(defaultCurrencyID: "usd", id: "4", name: "4")
        ])
            .setFailureType(to: NetworkErrorHandler.self)
            .eraseToAnyPublisher()
    }
}

class MockWelcomeServicesFailure: WelcomeServicesProtocol{
    func fetchSites() -> AnyPublisher<SitesModel, NetworkErrorHandler> {
        Fail(error: NetworkErrorHandler.requestFailed)
            .eraseToAnyPublisher()
    }
}

final class WelcomeProcessTest: XCTestCase {

    var successViewModel: WelcomeViewModel?
    var failureViewModel: WelcomeViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        successViewModel = WelcomeViewModel(welcomeServices: MockWelcomeServices())
        failureViewModel = WelcomeViewModel(welcomeServices: MockWelcomeServicesFailure())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        successViewModel = nil
        failureViewModel = nil
    }

    func test_SuccessFetchSites() throws {
        // Given
        guard let vm = successViewModel else {
            XCTFail()
            return
        }
        
        //When
        vm.fetchSites()
        
        //Then
        XCTAssertNotNil(vm.sites)
        XCTAssertFalse(vm.sites.isEmpty)
        XCTAssertTrue(isAlphabeticallySorted(array: vm.sites))
        XCTAssertFalse(vm.showReloadButton)
        XCTAssertNil(vm.lastApiError)
    }
    
    func test_FailureFetchSites() throws {
        // Given
        guard let vm = failureViewModel else {
            XCTFail()
            return
        }
        
        //When
        vm.fetchSites()
        
        //Then
        XCTAssertTrue(vm.sites.isEmpty)
        XCTAssertTrue(vm.showReloadButton)
        XCTAssertNotNil(vm.lastApiError)
    }
    
    // Function to check if an array is sorted alphabetically
    func isAlphabeticallySorted<T: Comparable>(array: [T]) -> Bool {
        return array == array.sorted()
    }
}
