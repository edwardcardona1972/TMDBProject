//
//  PeliculaError.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 31/3/25.
//
enum PeliculaError: Error {
    
    case apiError
    case respuestaInvalida
    
    var descripcion: String {
        switch self {
            case .apiError: return "Error en la API"
            case .respuestaInvalida: return "Respuesta invalida"
        }
    }
 }
