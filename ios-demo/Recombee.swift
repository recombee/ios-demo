//
//  Recombee.swift
//  ios-demo
//
//  Created by Jan Bednar on 04.04.2025.
//

import Foundation
import RecombeeClient

enum Recombee {
    static let client: RecombeeClient = {
        RecombeeClient(
            databaseId:"sample-organization-media-sample-db",
            publicToken:"ZVQBJERql0ctf93Vp8gQ0BdMAvwrEtMi6qzI2qrGcTUukkusdu4jn0TvFeiCp0bV",
            region: .euWest
        )
    }()
}
