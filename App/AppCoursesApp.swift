import SwiftUI

@main
struct AppCoursesApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeListView(recipes: [
                Recipe(id: 1, nom: "Pâtes Carbonara", description: "Un classique italien délicieux.", photo_url: "https://i.imgur.com/xyz123.jpg"),
                Recipe(id: 2, nom: "Soupe de légumes", description: "Une soupe réconfortante avec des carottes.", photo_url: "https://i.imgur.com/soupe.jpg")
            ])
        }
    }
}

