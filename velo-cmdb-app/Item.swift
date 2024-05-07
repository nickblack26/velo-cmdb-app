//
//  Item.swift
//  velo-cmdb-app
//
//  Created by Nick Black on 5/2/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
