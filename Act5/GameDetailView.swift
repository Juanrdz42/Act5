import SwiftUI

// Pantalla que consulta y presenta toda la información de un juego seleccionado.
struct GameDetailView: View {
    let game: Game
    @State private var viewModel = GameDetailViewModel()

    var body: some View {
        ScrollView {
            // Muestra progreso, error o contenido según el resultado de la petición.
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading game details...")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)

                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Unable to load game",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )

                } else if let detail = viewModel.gameDetail {
                    detailContent(detail)
                }
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)
        .tint(.appPrimary)
        // Solicita el detalle correspondiente cuando se abre esta pantalla.
        .task {
            await viewModel.getGameDetail(id: game.id)
        }
    }

    // Organiza la imagen, datos generales, descripción, información y capturas del juego.
    private func detailContent(_ detail: GameDetail) -> some View {
        VStack(alignment: .leading, spacing: 24) {

            AsyncImage(url: URL(string: detail.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 220)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 18))

            HStack(alignment: .center) {
                Text(detail.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()

                if let status = detail.status {
                    Text(status)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.green.opacity(0.15))
                        .foregroundStyle(.green)
                        .clipShape(Capsule())
                }
            }

            HStack(spacing: 12) {
                if let genre = detail.genre {
                    infoCard(
                        title: "Genre",
                        value: genre,
                        icon: "gamecontroller"
                    )
                }

                if let platform = detail.platform {
                    infoCard(
                        title: "Platform",
                        value: platform,
                        icon: "desktopcomputer"
                    )
                }
            }

            if let description = detail.description,
               !description.isEmpty {

                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(description)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 18) {
                Text("Game Information")
                    .font(.title2)
                    .fontWeight(.bold)

                if let releaseDate = detail.releaseDate {
                    informationRow(
                        title: "Released",
                        value: releaseDate,
                        icon: "calendar"
                    )
                }

                if let developer = detail.developer {
                    informationRow(
                        title: "Developer",
                        value: developer,
                        icon: "hammer"
                    )
                }

                if let publisher = detail.publisher {
                    informationRow(
                        title: "Publisher",
                        value: publisher,
                        icon: "building.2"
                    )
                }
            }

            if let screenshots = detail.screenshots,
               !screenshots.isEmpty {

                Divider()

                Text("Screenshots")
                    .font(.title2)
                    .fontWeight(.bold)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(screenshots) { screenshot in
                            AsyncImage(url: URL(string: screenshot.image)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 280, height: 160)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }

    // Crea una tarjeta compacta para destacar datos como género y plataforma.
    private func infoCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text(title)
                    .foregroundStyle(.secondary)
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(Color.appPrimary)
            }
            .font(.caption)

            Text(value)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appPrimary.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // Crea una fila reutilizable para los datos adicionales del juego.
    private func informationRow(
        title: String,
        value: String,
        icon: String
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.appPrimary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)

                Text(value)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
