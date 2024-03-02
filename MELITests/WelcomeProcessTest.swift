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
        Just(SitesModel())
            .setFailureType(to: NetworkErrorHandler.self)
            .eraseToAnyPublisher()
    }
}

class MockWelcomeServicesFailure: WelcomeServicesProtocol{
    func fetchSites() -> AnyPublisher<SitesModel, NetworkErrorHandler> {
        Just(SitesModel())
            .setFailureType(to: NetworkErrorHandler.self)
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
    
    // Function to check if an array is sorted alphabetically
    func isAlphabeticallySorted<T: Comparable>(array: [T]) -> Bool {
        return array == array.sorted()
    }
}
