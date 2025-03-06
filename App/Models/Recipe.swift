import Foundation

struct Recipe: Codable, Identifiable {
    let id: Int
    let nom: String
    let description: String
    let photo_url: String
}

