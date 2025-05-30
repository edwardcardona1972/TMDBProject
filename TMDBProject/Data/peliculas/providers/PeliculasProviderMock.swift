//
//  PeliculasProviderMock.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//


import Foundation
import Combine

class PeliculasProviderMock : PeliculasProviderProtocol {
    
    func obtenerPeliculas() -> AnyPublisher<ResponsePeliculasPopulares, ApiError> {
        guard let model = Utils.parseJson(jsonName: "maspopulares", model: ResponsePeliculasPopulares.self) else {
            return Fail(error: ApiError.respuestaInvalida).eraseToAnyPublisher()
        }
        return Just(model)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func getDetallesPelicula(peliculaId: String) -> AnyPublisher<ResponseDetallesPelicula, ApiError> {
        guard let model = Utils.parseJson(jsonName: "detallesPelicula", model: ResponseDetallesPelicula.self) else {
            return Fail (error: ApiError.respuestaInvalida).eraseToAnyPublisher()
        }
        return Just(model)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func buscarPeliculas(query: String) -> AnyPublisher<ResponsePeliculasPopulares, ApiError> {
          let emptyResponse = ResponsePeliculasPopulares(page: 1, results: [])
          return Just(emptyResponse)
              .setFailureType(to: ApiError.self)
              .eraseToAnyPublisher()
       }
}
