import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipeVM: RecipeViewModel
    
    @State private var nom: String = ""
    @State private var description: String = ""
    @State private var photoURL: String = ""
    @State private var showError: Bool = false // ✅ État pour afficher une alerte en cas d'erreur

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nom de la recette")) {
                    TextField("Nom", text: $nom)
                }
                Section(header: Text("Description")) {
                    TextField("Description", text: $description)
                }
                Section(header: Text("Photo URL")) {
                    TextField("Photo URL", text: $photoURL)
                }
                Section {
                    Button(action: ajouterRecette) { // ✅ Fonction dédiée pour éviter la duplication de code
                        Text("Ajouter la recette")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(nom.isEmpty || description.isEmpty) // ✅ Désactive le bouton si les champs sont vides
                }
            }
            .navigationTitle("➕ Nouvelle Recette")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
            .alert("Erreur", isPresented: $showError) { // ✅ Affiche une alerte en cas d'échec
                Button("OK", role: .cancel) { }
            } message: {
                Text("Impossible d'ajouter la recette. Vérifiez votre connexion.")
            }
        }
    }

    /// Fonction pour ajouter une recette via l'API
    private func ajouterRecette() {
        guard !nom.isEmpty, !description.isEmpty else { return }

        recipeVM.addRecipe(nom: nom, description: description, photoURL: photoURL) { success in
            if success {
                dismiss() // ✅ Ferme la vue en cas de succès
                print("✅ Recette ajoutée avec succès")
            } else {
                showError = true // ✅ Active l'alerte en cas d'échec
                print("❌ Échec de l'ajout de la recette")
            }
        }
    }
}
