//
//  PeliculaError.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 31/3/25.
//
import Foundation

enum ApiError: Error {

    case apiError
    case respuestaInvalida
    case invalidURL
    case networkError(URLError)
    case decodingError(Error)
    case httpStatusCodeError
    case unknown(error: Error) // ¡Añade este caso!

    var descripcion: String {
        switch self {
        case .apiError:
            return "Error en la API"
        case .respuestaInvalida:
            return "Respuesta inválida"
        case .invalidURL:
            return "La URL proporcionada no es válida"
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Error al decodificar los datos: \(error.localizedDescription)"
        case .httpStatusCodeError:
            return "Error de código de estado HTTP"
        case .unknown(let error):
            return "Error desconocido: \(error.localizedDescription)" // Añade una descripción para el caso unknown
        }
    }
}
