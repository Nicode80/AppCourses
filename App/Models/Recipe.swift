import Foundation

struct Recipe: Codable, Identifiable, Hashable {
    let id: Int
    let nom: String
    let description: String
    let photo_url: String

    // Ajout de la méthode `hash(into:)` pour la conformité à `Hashable`
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
