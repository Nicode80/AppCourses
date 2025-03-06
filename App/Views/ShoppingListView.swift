import SwiftUI

struct ShoppingListView: View {
    let selectedRecipes: [Recipe]
    @State private var shoppingList: [Ingredient] = []

    var body: some View {
        VStack(alignment: .leading) {
            Text("🛒 Liste de Courses")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if shoppingList.isEmpty {
                Text("Aucune recette sélectionnée.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(shoppingList, id: \.id) { ingredient in
                    HStack {
                        Text(ingredient.nom)
                        Spacer()
                        Text("\(ingredient.quantite) \(ingredient.unite ?? "")")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            fetchShoppingList()
        }
    }

    private func fetchShoppingList() {
        let recipeIDs = selectedRecipes.map { $0.id }.map(String.init).joined(separator: ",")
        guard let url = URL(string: "http://localhost:8055/items/ingredients?filter[recette_id][_in]=\(recipeIDs)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(IngredientResponse.self, from: data)
                DispatchQueue.main.async {
                    self.shoppingList = aggregateIngredients(decodedResponse.data)
                }
            } catch {
                print("Erreur lors du chargement des ingrédients:", error)
            }
        }.resume()
    }

    private func aggregateIngredients(_ ingredients: [Ingredient]) -> [Ingredient] {
        var aggregated: [String: Ingredient] = [:]

        for ingredient in ingredients {
            if let existing = aggregated[ingredient.nom] {
                aggregated[ingredient.nom] = Ingredient(
                    id: existing.id,
                    nom: existing.nom,
                    unite: existing.unite,
                    categorie: existing.categorie, // Ajout de la catégorie
                    recette_id: existing.recette_id, // Ajout du recette_id
                    quantite: existing.quantite + ingredient.quantite, // Ajout des quantités
                    optionnel: existing.optionnel // Ajout du booléen optionnel
                )
            } else {
                aggregated[ingredient.nom] = ingredient
            }

        }
        return Array(aggregated.values)
    }
}
//
//  ShoppingListView.swift
//  AppCourses
//
//  Created by Nicolas Constantin on 06/03/2025.
//

