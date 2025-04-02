//
//  PeliculasProviderMock.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//


import Foundation

class PeliculasProviderMock : PeliculasProviderProtocol {
    func getPeliculas(page: String, completed: @escaping (Result<ResponseMasPopulares, PeliculaError>) -> ()) {
        guard let model = Utils.parseJson(jsonName: "maspopulares", model: ResponseMasPopulares.self)
        else{
            completed(.failure(.respuestaInvalida))
            return
        }
        completed(Result.success(model))
    }

    func getDetallesPelicula(peliculaId: String, completed: @escaping (Result<ResponseDetallesPelicula, PeliculaError>) -> ()) {
        guard let model = Utils.parseJson(jsonName: "detallesPelicula", model: ResponseDetallesPelicula.self)
        else {
            completed(.failure(.respuestaInvalida))
            return
        }
        completed(Result.success(model))
    }
}
