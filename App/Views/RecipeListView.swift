import SwiftUI

struct RecipeListView: View {
    @ObservedObject var recipeVM = RecipeViewModel()
    @State private var selectedRecipes: [Recipe] = []
    @State private var navigateToShoppingList = false

    var body: some View {
        NavigationView {
            VStack {
                List(recipeVM.recipes) { recipe in
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

                NavigationLink(destination: ShoppingListView(selectedRecipes: selectedRecipes), isActive: $navigateToShoppingList) {
                    EmptyView()
                }
                
                Button("🛒 Générer la liste de courses") {
                    navigateToShoppingList = true
                }
                .padding()
                .disabled(selectedRecipes.isEmpty)
            }
            .navigationTitle("🍽️ Sélectionnez des recettes")
            .onAppear {
                recipeVM.fetchRecipes()
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
