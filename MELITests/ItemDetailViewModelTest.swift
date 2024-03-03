//
//  ItemDetailViewModelTest.swift
//  MELITests
//
//  Created by Thony Gonzalez on 2/03/24.
//

import XCTest

final class ItemDetailViewModelTest: XCTestCase {
    
    var successViewModel: ItemDetailViewModel?
    var failureViewModel: ItemDetailViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        successViewModel = ItemDetailViewModel(mainAppService: MockMainAppService(), itemId: "MCO909960201")
        failureViewModel = ItemDetailViewModel(mainAppService: FailureMockMainAppService(), itemId: "MCO909960201")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        successViewModel = nil
        failureViewModel = nil
    }

    func test_SuccessGetItemDetail() {
        //Given
        guard let vm = successViewModel else {
            XCTFail()
            return
        }
        
        //When
        vm.getItemDetail()
        
        //Then
        XCTAssertNotNil(vm.itemDetailData)
        XCTAssertNil(vm.lastApiError)
    }
    
    func test_FailureGetItemDetail() {
        //Given
        guard let vm = failureViewModel else {
            XCTFail()
            return
        }
        
        //When
        vm.getItemDetail()
        
        //Then
        XCTAssertNil(vm.itemDetailData)
        XCTAssertNotNil(vm.lastApiError)
    }
    
    func test_CalculateDiscountPercentage() throws {
        //Given
        guard let vm = successViewModel else {
            XCTFail()
            return
        }

        //When
        // Case 1: Valid discount
        let discountPercentage1 = vm.calculateDiscountPercentage(originalValue: 100.0, valueWithDiscount: 80.0)
        
        // Case 2: Discount equal to the original value
        let discountPercentage2 = vm.calculateDiscountPercentage(originalValue: 100.0, valueWithDiscount: 100.0)
        
        // Case 3: Discount value greater than the original value
        let discountPercentage3 = vm.calculateDiscountPercentage(originalValue: 80.0, valueWithDiscount: 100.0)
        
        //Then
        XCTAssertEqual(discountPercentage1, "20", "The discount should be 20%")

        XCTAssertEqual(discountPercentage2, "0", "The discount should be 0%")

        XCTAssertEqual(discountPercentage3, "0", "The discount should be 0%")
    }
}
