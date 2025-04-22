//
//  PeliculasProviderProtocol.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//

import Foundation
import Combine

protocol peliculasProviderProtocol {
    func obtenerPeliculas(page: String) -> AnyPublisher<ResponseMasPopulares, PeliculaError>
    func getDetallesPelicula(peliculaId: String) -> AnyPublisher<ResponseDetallesPelicula, PeliculaError>
    func buscarPeliculas(query: String) -> AnyPublisher<ResponseMasPopulares, PeliculaError>
}
