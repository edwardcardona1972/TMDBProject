//
//  PeliculasProviderProtocol.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//

import Foundation
import Combine

protocol PeliculasProviderProtocol {
    func obtenerPeliculas() -> AnyPublisher<ResponsePeliculasPopulares, ApiError>
    func getDetallesPelicula(peliculaId: String) -> AnyPublisher<ResponseDetallesPelicula, ApiError>
    func buscarPeliculas(query: String) -> AnyPublisher<ResponsePeliculasPopulares, ApiError>
}
