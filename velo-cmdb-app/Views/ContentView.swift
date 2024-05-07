import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(CallManager.self) private var callManager
    @Environment(SupabaseManager.self) private var supabase
    @Environment(\.modelContext) private var modelContext
    
    @State private var tickets: [Ticket] = []
    @State private var showCall: Bool = false
    
    var body: some View {
        VStack {
            Text("Hey")
            ForEach(tickets) { ticket in
                Text(ticket.summary)
            }
            DialView()
        }
        .task {
            do {
               tickets = try await supabase.client.from("tickets").select("id, summary").execute().value
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    DialView()
}
