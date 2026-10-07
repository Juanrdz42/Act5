# Actividad 5 - Consumo de API

Esta aplicación fue desarrollada en SwiftUI con el objetivo de practicar el consumo de una API externa y mostrar la información obtenida dentro de una aplicación móvil.

La aplicación permite explorar distintos videojuegos free-to-play. En la pantalla principal se muestra una lista de juegos con su imagen, género y plataforma. Al seleccionar uno, se puede consultar información más detallada como su descripción, fecha de lanzamiento, desarrollador, publisher, estado y algunas capturas del juego.

## API utilizada

Para obtener la información se utilizó la API pública de FreeToGame.

Endpoints utilizados:

- Lista de juegos  
  https://www.freetogame.com/api/games

- Información de un juego  
  https://www.freetogame.com/api/game?id={id}

Documentación de la API:  
https://www.freetogame.com/api-doc

Esta API no requiere autenticación ni API key.

## Funcionalidades

- Consulta de videojuegos mediante una API
- Visualización de imagen, género y plataforma
- Navegación entre una lista y la información detallada de cada juego
- Información sobre desarrollador, publisher y fecha de lanzamiento
- Galería de screenshots
- Indicador de carga mientras se realizan las peticiones
- Manejo de errores de conexión y respuestas de la API

## Arquitectura

Para organizar el proyecto se utilizó MVVM. Los modelos representan la información recibida de la API, los ViewModels se encargan de realizar las peticiones y manejar el estado de la aplicación, y las Views muestran la información utilizando SwiftUI.

## Cómo ejecutar el proyecto

1. Clonar o descargar este repositorio.
2. Abrir el proyecto en Xcode.
3. Seleccionar un simulador de iPhone.
4. Ejecutar la aplicación con el botón Run.

Es necesario tener conexión a internet para consultar la información de FreeToGame.

## Tecnologías utilizadas

- Swift
- SwiftUI
- URLSession
- Codable
- MVVM

Los datos e imágenes utilizados en la aplicación son proporcionados por FreeToGame.
