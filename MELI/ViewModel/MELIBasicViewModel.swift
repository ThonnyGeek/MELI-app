//
//  MELIBasicViewModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 1/03/24.
//

import Foundation
import Combine

protocol MELIBasicViewModel {
    func onReceive(_ completion: Subscribers.Completion<NetworkErrorHandler>) -> NetworkErrorHandler?
}

extension MELIBasicViewModel {
    /// To handle completion
    func onReceive(_ completion: Subscribers.Completion<NetworkErrorHandler>) -> NetworkErrorHandler? {
        switch completion {
        case .finished:
            print("APIClient call finished")
            return nil
        case .failure(let failure):
            return failure
        }
    }
}
