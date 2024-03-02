//
//  SearchBarViewModelTest.swift
//  MELITests
//
//  Created by Thony Gonzalez on 1/03/24.
//

import XCTest
import Combine

class MockMainAppService: MainAppServiceProtocol {
    func fetchSearchItems(query: String) -> AnyPublisher<SearchItemsModel, NetworkErrorHandler> {
        Just(SearchItemsModel(query: "query", paging: Paging(total: 1, primaryResults: 1, offset: 1, limit: 1), results: [Result(id: "", title: "", condition: "", thumbnailID: "", thumbnail: "", price: 0, originalPrice: 0, shipping: nil, installments: nil, attributes: nil)]))
            .setFailureType(to: NetworkErrorHandler.self)
            .eraseToAnyPublisher()
    }
    
    func loadMoreSearchItems(query: String, offset: String) -> AnyPublisher<SearchItemsModel, NetworkErrorHandler> {
        Just(SearchItemsModel(query: "query", paging: Paging(total: 1, primaryResults: 1, offset: 1, limit: 1), results: [Result(id: "", title: "", condition: "", thumbnailID: "", thumbnail: "", price: 0, originalPrice: 0, shipping: nil, installments: nil, attributes: nil)]))
            .setFailureType(to: NetworkErrorHandler.self)
            .eraseToAnyPublisher()
    }
}

class FailureMockMainAppService: MainAppServiceProtocol {
    func fetchSearchItems(query: String) -> AnyPublisher<SearchItemsModel, NetworkErrorHandler> {
        Fail(error: NetworkErrorHandler.invalidURL)
            .eraseToAnyPublisher()
    }
    
    func loadMoreSearchItems(query: String, offset: String) -> AnyPublisher<SearchItemsModel, NetworkErrorHandler> {
        Fail(error: NetworkErrorHandler.invalidURL)
            .eraseToAnyPublisher()
    }
}

final class SearchBarViewModelTest: XCTestCase {
    
    var successViewModel: SearchBarViewModel?
    var failureViewModel: SearchBarViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        successViewModel = SearchBarViewModel(mainAppService: MockMainAppService())
        failureViewModel = SearchBarViewModel(mainAppService: FailureMockMainAppService())
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        successViewModel = nil
        failureViewModel = nil
    }

    func test_SuccessFetchSearchItems() throws {
        
        let expectation = expectation(description: "Value should change")
        
        //Given
        guard let vm = successViewModel else {
            XCTFail()
            return
        }
        
        //When
        var isLoadingObserver: AnyCancellable?
        isLoadingObserver = vm.$isLoading.sink { newValue in
            // Assert
            XCTAssertEqual(newValue, true) // Ajusta según lo que esperas que sea el nuevo valor
            expectation.fulfill()
            
            // Cancelar la observación después de la verificación
            isLoadingObserver?.cancel()
        }
        
        vm.fetchSearchItems()
        
        //Then
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.searchItemsResults.isEmpty)
    }
    
    func test_SuccessLoadMoreSearchItems() throws {
        
        let expectation = expectation(description: "Value should change")
        
        //Given
        guard let vm = successViewModel else {
            XCTFail()
            return
        }
        
        let initialSearchItemsResultsCount = vm.searchItemsResults.count
        
        //When
        var isLoadingObserver: AnyCancellable?
        isLoadingObserver = vm.$isLoading.sink { newValue in
            // Assert
            XCTAssertEqual(newValue, true) // Ajusta según lo que esperas que sea el nuevo valor
            expectation.fulfill()
            
            // Cancelar la observación después de la verificación
            isLoadingObserver?.cancel()
        }
        
        vm.loadMoreSearchItems()
        
        // Esperar a que se cumpla la expectativa
        wait(for: [expectation], timeout: 5.0)
        
        //Then
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.searchItemsResults.isEmpty)
        XCTAssertLessThan(initialSearchItemsResultsCount, vm.searchItemsResults.count)
    }
}
