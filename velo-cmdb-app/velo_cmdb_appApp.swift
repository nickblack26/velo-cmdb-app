//
//  velo_cmdb_appApp.swift
//  velo-cmdb-app
//
//  Created by Nick Black on 5/2/24.
//

import SwiftUI
import SwiftData

@main
struct velo_cmdb_appApp: App {
    @State private var callManager = CallManager()
    @State private var supabaseMangager = SupabaseManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Ticket.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(callManager)
        .environment(supabaseMangager)
        .modelContainer(sharedModelContainer)
    }
}
