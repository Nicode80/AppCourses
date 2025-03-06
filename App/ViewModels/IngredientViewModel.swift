import Foundation

class IngredientViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []

    func fetchIngredients(for recipeId: Int) {
        guard let url = URL(string: "http://localhost:8055/items/ingredients?filter[recette_id]=\(recipeId)") else {
            print("URL invalide")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erreur lors de la requête API : \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Données vides")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(IngredientResponse.self, from: data)
                DispatchQueue.main.async {
                    self.ingredients = decodedResponse.data
                }
            } catch {
                print("Erreur lors du décodage JSON : \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct IngredientResponse: Codable {
    let data: [Ingredient]
}
