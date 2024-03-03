//
//  Constants.swift
//  MELI
//
//  Created by Thony Gonzalez on 1/03/24.
//

import Foundation
import SwiftUI

struct Constants {
    static let baseURL: String = "https://api.mercadolibre.com"
    
    #if !TESTING
    static let screenSize: CGRect = (UIScreen.current?.bounds ?? UIScreen.main.bounds)
    #endif
}
