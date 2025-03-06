import Foundation

struct Ingredient: Codable, Identifiable {
    let id: Int
    let nom: String
    let unite: String?
    let categorie: String?  // Ajout de la catégorie
    let recette_id: Int     // Ajout de l'ID de la recette associée
    var quantite: Int       // ✅ Correction : let -> var pour rendre la quantité modifiable
    let optionnel: Bool     // Ajout du champ optionnel
}
