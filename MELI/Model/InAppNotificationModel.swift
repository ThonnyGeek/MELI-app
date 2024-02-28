//
//  InAppNotificationModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation

struct InAppNotificationModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let bodyText: String?
    let theme: CNTheme
    
    init(title: String, bodyText: String? = nil, theme: CNTheme) {
        self.title = title
        self.bodyText = bodyText
        self.theme = theme
    }
}
