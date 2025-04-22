//
//  PeliculasProviderMock.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//


import Foundation
import Combine

class PeliculasProviderMock : peliculasProviderProtocol {
    
    func obtenerPeliculas(page: String) -> AnyPublisher<ResponseMasPopulares, PeliculaError> {
        guard let model = Utils.parseJson(jsonName: "maspopulares", model: ResponseMasPopulares.self) else {
            return Fail(error: PeliculaError.respuestaInvalida).eraseToAnyPublisher()
        }
        return Just(model)
            .setFailureType(to: PeliculaError.self)
            .eraseToAnyPublisher()
    }
    
    func getDetallesPelicula(peliculaId: String) -> AnyPublisher<ResponseDetallesPelicula, PeliculaError> {
        guard let model = Utils.parseJson(jsonName: "detallesPelicula", model: ResponseDetallesPelicula.self) else {
            return Fail (error: PeliculaError.respuestaInvalida).eraseToAnyPublisher()
        }
        return Just(model)
            .setFailureType(to: PeliculaError.self)
            .eraseToAnyPublisher()
    }
    
    func buscarPeliculas(query: String) -> AnyPublisher<ResponseMasPopulares, PeliculaError> {
          let emptyResponse = ResponseMasPopulares(page: 1, results: [])
          return Just(emptyResponse)
              .setFailureType(to: PeliculaError.self)
              .eraseToAnyPublisher()
       }
}
