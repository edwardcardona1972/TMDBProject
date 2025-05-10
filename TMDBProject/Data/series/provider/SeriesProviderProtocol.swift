//
//  SeriesProviderProtocol.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 8/5/25.
//

import Foundation
import Combine

protocol SeriesProviderProtocol {
    func obtenerSeriesPopulares(pagina: String) -> AnyPublisher<ResponseSeriesPopulares, ApiError>
}

