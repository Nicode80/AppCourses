import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []

    /// Récupère les recettes depuis l'API
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

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Réponse invalide")
                return
            }

            guard httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP \(httpResponse.statusCode)")
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

    /// Ajoute une nouvelle recette à l'API
    func addRecipe(nom: String, description: String, photoURL: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:8055/items/recettes") else {
            print("❌ URL invalide")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let newRecipe = ["nom": nom, "description": description, "photo_url": photoURL]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newRecipe, options: [])
        } catch {
            print("❌ Erreur encodage JSON : \(error)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Erreur lors de l'ajout de la recette : \(error)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Réponse invalide")
                completion(false)
                return
            }

            guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
                print("❌ Erreur HTTP \(httpResponse.statusCode)")
                completion(false)
                return
            }

            DispatchQueue.main.async {
                self.fetchRecipes() // 🔄 Recharge la liste des recettes après ajout
                print("✅ Recette ajoutée et liste mise à jour")
                completion(true)
            }
        }.resume()
    }
}

// Structure de réponse attendue depuis Directus
struct RecipeResponse: Codable {
    let data: [Recipe]
}
