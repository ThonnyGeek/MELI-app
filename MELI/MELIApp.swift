//
//  MELIApp.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import SwiftUI

@main
struct MELIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
