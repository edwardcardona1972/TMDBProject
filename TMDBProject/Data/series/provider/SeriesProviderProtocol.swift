//
//  SeriesProviderProtocol.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 8/5/25.
//

import Foundation
import Combine

protocol SeriesProviderProtocol {
    func obtenerSeriesPopulares() -> AnyPublisher<ResponseSeriesPopulares, ApiError>
    
    //func obtenerDetalleSeries(idSerie: String) -> AnyPublisher<ResponseDetallesSerie, ApiError>
}

