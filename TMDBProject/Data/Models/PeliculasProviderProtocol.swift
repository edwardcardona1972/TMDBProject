//
//  PeliculasProviderProtocol.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//

import Foundation
import Combine

protocol PeliculasProviderProtocol {
    func getPeliculas() -> AnyPublisher<ResponseMasPopulares, Error>
}
