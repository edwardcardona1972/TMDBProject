//
//  PeliculasProviderMock.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//


import Foundation
import Combine

class PeliculasProviderMock : PeliculasProviderProtocol {
    func getPeliculas(page: String) -> AnyPublisher<ResponseMasPopulares, PeliculaError> {
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
}

