// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let call = try Ticket(json)

import Foundation
import SwiftData

struct TicketDTO: Identifiable, Codable {
    let id: Int
    let summary: String
}

// MARK: - Call
@Model
final class Ticket: Codable {
    @Attribute(.unique) let id: Int
    let summary: String
    
    init(
        id: Int,
        summary: String
    ) {
        self.id = id
        self.summary = summary
    }
    
    enum CodingKeys: CodingKey {
        case id, summary
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        summary = try container.decode(String.self, forKey: .summary)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(summary, forKey: .summary)
    }
    
    func addData() {
        Task {
            do {
//                try await supabase.from("tickets").insert(Ticket(id: self.id, summary: self.summary)).execute()
            } catch {
                print(error)
            }
        }
    }
}
