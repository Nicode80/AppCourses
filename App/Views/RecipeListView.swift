import SwiftUI

struct RecipeListView: View {
    @ObservedObject var recipeVM = RecipeViewModel()
    @State private var selectedRecipes: [Recipe] = []
    @State private var navigateToShoppingList = false
    @State private var showAddRecipeView = false // ✅ État pour afficher l'ajout de recette

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
            .sheet(isPresented: $showAddRecipeView) { // ✅ Afficher la vue d'ajout de recette
                AddRecipeView(recipeVM: recipeVM) // ✅ On passe le ViewModel
            }
            .overlay(
                Button(action: {
                    showAddRecipeView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .shadow(radius: 4)
                }
                .padding()
                .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 150) // ✅ Position en bas à droite
            )
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
