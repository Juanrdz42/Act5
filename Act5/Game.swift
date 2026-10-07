import Foundation

// Representa la información resumida de un juego recibida en el listado de la API.
struct Game: Codable, Identifiable {
    let id: Int
    let title: String
    let thumbnail: String?
    let shortDescription: String?
    let genre: String?
    let platform: String?
    let publisher: String?
    let developer: String?
    let releaseDate: String?

    // Relaciona los nombres snake_case del JSON con propiedades escritas en camelCase.
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
        case shortDescription = "short_description"
        case genre
        case platform
        case publisher
        case developer
        case releaseDate = "release_date"
    }
}

// Contiene la información completa que se muestra en la pantalla de detalle.
struct GameDetail: Codable {
    let id: Int
    let title: String
    let thumbnail: String?
    let status: String?
    let shortDescription: String?
    let description: String?
    let gameURL: String?
    let genre: String?
    let platform: String?
    let publisher: String?
    let developer: String?
    let releaseDate: String?
    let screenshots: [Screenshot]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
        case status
        case shortDescription = "short_description"
        case description
        case gameURL = "game_url"
        case genre
        case platform
        case publisher
        case developer
        case releaseDate = "release_date"
        case screenshots
    }
}

// Modela cada captura de pantalla asociada con un juego.
struct Screenshot: Codable, Identifiable {
    let id: Int
    let image: String
}
