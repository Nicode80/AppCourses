import Foundation

struct Ingredient: Codable, Identifiable {
    let id: Int
    let nom: String
    let unite: String?
    let quantite: Int
}

