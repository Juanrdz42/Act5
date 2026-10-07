import SwiftUI
import UIKit

extension Color {
    static let appPrimary = Color(red: 88 / 255, green: 86 / 255, blue: 214 / 255)
    static let appSecondary = Color(red: 124 / 255, green: 111 / 255, blue: 232 / 255)

    static let appBackground = Color(
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 18 / 255, green: 18 / 255, blue: 26 / 255, alpha: 1)
                : UIColor(red: 244 / 255, green: 244 / 255, blue: 250 / 255, alpha: 1)
        }
    )

    static let appCard = Color(
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 28 / 255, green: 28 / 255, blue: 38 / 255, alpha: 1)
                : .white
        }
    )
}

struct ContentView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading games...")

                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Unable to load games",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )

                } else {
                    ScrollView {
                        LazyVStack(spacing: 18) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Game Explorer")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)

                                Text("Discover free-to-play games")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Capsule()
                                    .fill(Color.appPrimary)
                                    .frame(width: 40, height: 4)
                                    .padding(.top, 2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 4)

                            ForEach(viewModel.games) { game in
                                NavigationLink {
                                    GameDetailView(game: game)
                                } label: {
                                    gameCard(game)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground.ignoresSafeArea())
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .tint(.appPrimary)
        .task {
            await viewModel.getGames()
        }
    }

    private func gameCard(_ game: Game) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            AsyncImage(url: URL(string: game.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 190)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 14))

            Text(game.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            HStack(spacing: 10) {
                if let genre = game.genre {
                    Label(genre, systemImage: "gamecontroller")
                        .foregroundStyle(Color.appPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.appPrimary.opacity(0.12))
                        .clipShape(Capsule())
                }

                Spacer()

                if let platform = game.platform {
                    Label(platform, systemImage: "desktopcomputer")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.subheadline)
        }
        .padding(12)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
    }
}
