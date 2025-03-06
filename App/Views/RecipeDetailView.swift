import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @StateObject private var ingredientVM = IngredientViewModel() // Utilisation du ViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: recipe.photo_url)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                .scaledToFit()

                Text(recipe.nom)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Text(recipe.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.bottom)

                Text("Ingrédients")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)

                if ingredientVM.ingredients.isEmpty {
                    Text("Chargement des ingrédients...")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(ingredientVM.ingredients, id: \.id) { ingredient in
                        HStack {
                            Text(ingredient.nom)
                            Spacer()
                            Text("\(ingredient.quantite) \(ingredient.unite ?? "")")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 300) // Ajuste la hauteur de la liste pour éviter les problèmes d'affichage
                }
            }
            .padding()
        }
        .navigationTitle("Recette")
        .onAppear {
            ingredientVM.fetchIngredients(for: recipe.id) // Appel API au chargement
        }
    }
}
