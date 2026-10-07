import Foundation

// Gestiona el estado de la pantalla principal y obtiene el catálogo desde la API.
@Observable
class GameViewModel {

    // Datos observables que la vista utiliza para representar sus distintos estados.
    var games = [Game]()
    var isLoading = false
    var errorMessage: String?

    // Descarga y decodifica el listado, validando la respuesta y controlando errores.
    @MainActor
    func getGames() async {

        isLoading = true
        errorMessage = nil

        // Garantiza que el indicador termine aunque la función salga por un error.
        defer {
            isLoading = false
        }

        guard let url = URL(
            string: "https://www.freetogame.com/api/games"
        ) else {
            errorMessage = "Invalid URL."
            return
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid server response."
                return
            }

            guard httpResponse.statusCode == 200 else {
                errorMessage = "API error. Code: \(httpResponse.statusCode)"
                return
            }

            games = try JSONDecoder().decode(
                [Game].self,
                from: data
            )

        } catch let error as URLError {

            if error.code == .notConnectedToInternet {
                errorMessage = "No connection. Please try again."
            } else {
                errorMessage = "Network error. Please try again."
            }

        } catch {
            errorMessage = "Something went wrong. Please try again."
        }
    }
}
