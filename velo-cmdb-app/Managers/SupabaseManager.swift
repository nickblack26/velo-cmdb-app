import Foundation
import SwiftData
import Supabase

@Observable
class SupabaseManager {
    var client: SupabaseClient
    
    init() {
        self.client = SupabaseClient(
            supabaseURL: URL(
                string: ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
            )!,
            supabaseKey: ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
        )
//        let dirPaths = NSSearchPathForDirectoriesInDomains(.adminApplicationDirectory, .userDomainMask, true)
//        print(dirPaths)
//        if let deviceName = Host.current().name {
//            print(deviceName)
//        }
    }
    
    @MainActor
    func updateDataInDatabase(modelContext: ModelContext) async {
        do {
            let itemData: [TicketDTO] = try await client
                .from("tickets")
                .select("id, summary, recordType")
                .execute()
                .value
            
            for eachItem in itemData {
                let itemToStore = Ticket(id: eachItem.id, summary: eachItem.summary)
                modelContext.insert(itemToStore)
            }
        } catch {
            print("Error fetching data")
            print(error)
        }
    }
}
