//
//  PeliculasProviderProtocol.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//

import Foundation
import Combine

protocol PeliculasProviderProtocol {
    func getPeliculas(page: String) -> AnyPublisher<ResponseMasPopulares, PeliculaError>
    func getDetallesPelicula(peliculaId: String) -> AnyPublisher<ResponseDetallesPelicula, PeliculaError>
}
