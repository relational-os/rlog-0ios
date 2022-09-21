//
//  LogApp.swift
//  Shared
//
//  Created by CJ Pais on 7/8/22.
//

import SwiftUI

@main
struct LogApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
