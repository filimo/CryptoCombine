//
//  CryptoCombineApp.swift
//  Shared
//
//  Created by Viktor Kushnerov on 22.04.21.
//

import SwiftUI

@main
struct CryptoCombineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            CloudKitView()
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
