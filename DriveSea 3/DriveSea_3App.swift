//
//  DriveSea_3App.swift
//  DriveSea 3
//
//  Created by FelixWither on 2024/12/29.
//

import SwiftUI

@main
struct DriveSea_3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
