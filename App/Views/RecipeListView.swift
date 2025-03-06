import SwiftUI

struct RecipeListView: View {
    @ObservedObject var recipeVM = RecipeViewModel()
    @State private var selectedRecipes: [Recipe] = []
    @State private var navigateToShoppingList = false

    var body: some View {
        NavigationStack {
            VStack {
                if recipeVM.recipes.isEmpty {
                    Text("🔄 Chargement des recettes...")
                        .font(.headline)
                } else {
                    List(recipeVM.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            HStack {
                                AsyncImage(url: URL(string: recipe.photo_url)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                                Text(recipe.nom)
                                Spacer()
                                Image(systemName: selectedRecipes.contains(where: { $0.id == recipe.id }) ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        toggleSelection(recipe)
                                    }
                            }
                        }
                    }
                }

                Button("🛒 Générer la liste de courses") {
                    if !selectedRecipes.isEmpty {
                        print("✅ Bouton cliqué, navigation vers ShoppingListView")
                        navigateToShoppingList = true
                    }
                }
                .padding()
                .disabled(selectedRecipes.isEmpty)

            }
            .navigationTitle("🍽️ Sélectionnez des recettes")
            .onAppear {
                print("🟢 RecipeListView apparaît")
                recipeVM.fetchRecipes()
            }
            .navigationDestination(isPresented: $navigateToShoppingList) {
                ShoppingListView(selectedRecipes: selectedRecipes)
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }

    private func toggleSelection(_ recipe: Recipe) {
        if let index = selectedRecipes.firstIndex(where: { $0.id == recipe.id }) {
            selectedRecipes.remove(at: index)
        } else {
            selectedRecipes.append(recipe)
        }
    }
}
