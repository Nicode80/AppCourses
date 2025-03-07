import SwiftUI

struct RecipeFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipeVM: RecipeViewModel

    @State private var nom: String = ""
    @State private var description: String = ""
    @State private var photoURL: String = "" // Correction ici (photoURL au lieu de photo_url)

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nom de la recette")) {
                    TextField("Nom", text: $nom)
                }
                Section(header: Text("Description")) {
                    TextField("Description", text: $description)
                }
                Section(header: Text("URL de l'image")) {
                    TextField("URL", text: $photoURL)
                }
                Section {
                    Button("Ajouter la recette") {
                        addRecipe() // ✅ On appelle la fonction addRecipe()
                    }
                    .disabled(nom.isEmpty || description.isEmpty || photoURL.isEmpty) // Désactivation si vide
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
        }
    }

    private func addRecipe() {
        guard !nom.isEmpty, !description.isEmpty, !photoURL.isEmpty else { return }

        recipeVM.addRecipe(nom: nom, description: description, photoURL: photoURL) { success in
            if success {
                dismiss()
            }
        }
    }
}
