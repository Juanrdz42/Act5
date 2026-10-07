import Foundation

@Observable
class GameViewModel {

    var games = [Game]()
    var isLoading = false
    var errorMessage: String?

    @MainActor
    func getGames() async {

        isLoading = true
        errorMessage = nil

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
