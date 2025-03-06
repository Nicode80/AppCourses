import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []

    func fetchRecipes() {
        print("🟡 fetchRecipes() a été appelée") // Vérifier si la fonction est bien exécutée

        guard let url = URL(string: "http://localhost:8055/items/recettes") else {
            print("❌ URL invalide")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Erreur réseau :", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("❌ Aucune donnée reçue")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                DispatchQueue.main.async {
                    self.recipes = decodedResponse.data
                    print("✅ \(self.recipes.count) recettes chargées avec succès")
                }
            } catch {
                print("❌ Erreur de décodage JSON :", error)
            }
        }.resume()
    }
}

// Structure de réponse attendue depuis Directus
struct RecipeResponse: Codable {
    let data: [Recipe]
}
