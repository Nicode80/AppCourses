import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []

    func fetchRecipes() {
        guard let url = URL(string: "http://localhost:8055/items/recettes") else {
            print("URL invalide")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(DirectusResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.recipes = decodedResponse.data
                    }
                } catch {
                    print("Erreur de décodage JSON : \(error)")
                }
            }
        }
        task.resume()
    }
}

struct DirectusResponse: Codable {
    let data: [Recipe]
}

