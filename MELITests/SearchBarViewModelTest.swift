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
    
    func getItemDetail(id: String) -> AnyPublisher<ItemDetailsModelElement?, NetworkErrorHandler> {
        let pics = [
            Picture(id: "2", url: "", secureURL: "https://http2.mlstatic.com/D_631993-MLA46153270440_052021-O.jpg", size: "", maxSize: "", quality: ""),
            Picture(id: "1", url: "", secureURL: "https://http2.mlstatic.com/D_904849-MLA46153369025_052021-O.jpg", size: "", maxSize: "", quality: ""),
            Picture(id: "3", url: "", secureURL: "https://http2.mlstatic.com/D_851350-MLA46153270441_052021-O.jpg", size: "", maxSize: "", quality: "")
        ]
        
        return Just(ItemDetailsModelElement(code: 200, body: ItemDetailBody(id: "MCO909960201", message: nil, title: "Apple iPhone 11 (128 Gb) - Blanco", price: 2454000, originalPrice: 3506900, condition: "new", thumbnailID: "904849-MLA46153369025_052021", thumbnail: "http://http2.mlstatic.com/D_904849-MLA46153369025_052021-I.jpg", pictures: pics, shipping: nil, attributes: nil)))
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
    
    func getItemDetail(id: String) -> AnyPublisher<ItemDetailsModelElement?, NetworkErrorHandler> {
        Fail(error: NetworkErrorHandler.invalidURL)
            .eraseToAnyPublisher()
    }
}

final class SearchBarViewModelTest: XCTestCase {
    
    var successViewModel: SearchBarViewModel?
    var failureViewModel: SearchBarViewModel?
    var isLoadingObserver: AnyCancellable?

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
        isLoadingObserver = vm.$isLoading
            .dropFirst()
            .sink { newValue in
            // Assert
            XCTAssertEqual(newValue, true)
            expectation.fulfill()
            
            // Cancell after the verification
                self.isLoadingObserver?.cancel()
        }
        
        vm.fetchSearchItems()
        
        wait(for: [expectation], timeout: 10)
        
        //Then
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.searchItemsResults.isEmpty)
    }
    
    func test_SuccessLoadMoreSearchItems() throws {
        
        //Given
        guard let vm = successViewModel else {
            XCTFail()
            return
        }
        
        let initialSearchItemsResultsCount = vm.searchItemsResults.count
        
        //When
        
        vm.loadMoreSearchItems()
        
        //Then
        XCTAssertFalse(vm.searchItemsResults.isEmpty)
        XCTAssertLessThan(initialSearchItemsResultsCount, vm.searchItemsResults.count)
    }
}
