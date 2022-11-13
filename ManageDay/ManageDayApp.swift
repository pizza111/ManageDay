//
//  ManageDayApp.swift
//  ManageDay
//
//  Created by Piotr Woźniak on 13/11/2022.
//

import SwiftUI

@main
struct ManageDayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
