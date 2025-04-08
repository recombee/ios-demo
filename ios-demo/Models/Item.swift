//
//  Item.swift
//  ios-demo
//
//  Created by Jan Bednar on 04.04.2025.
//

import Foundation
import RecombeeClient

struct Item: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let images: [String]
}

enum ItemDecodingError: LocalizedError {
    case missingValues
    case missingValue(String)

    var errorDescription: String? {
        switch self {
        case .missingValues:
            return "There were no values in the recommendation. Have you forgot to add returnProperties: true in the request?"
        case .missingValue(let missingValue):
            return "Missing value for: \(missingValue)"
        }
    }
}

extension Item {
    init(recommendation: Recommendation) throws {
        guard let values = recommendation.values else {
            throw ItemDecodingError.missingValues
        }
        guard let title = values["title"] as? String else {
            throw ItemDecodingError.missingValue("title")
        }
        guard let description = values["description"] as? String else {
            throw ItemDecodingError.missingValue("description")
        }
        guard let images = values["images"] as? [String] else {
            throw ItemDecodingError.missingValue("images")
        }
        self.id = recommendation.id
        self.title = title
        self.description = description
        self.images = images
    }
}
