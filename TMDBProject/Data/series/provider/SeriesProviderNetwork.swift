//
//  SeriesProviderNetwork.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 1/5/25.
//

import Foundation
import Combine

class SeriesProviderNetwork: SeriesProviderProtocol {
    
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    private var page = 1
    
    private func handleSeriesError(_ error: Error) -> ApiError {
        if let peliculaError = error as? ApiError {
            return peliculaError
        } else if let decodingError = error as? DecodingError {
            print("🔴 Error de decodificación en Series: \(decodingError)")
            return ApiError.apiError
        } else {
            return ApiError.apiError
        }
    }
    
    func obtenerSeriesPopulares() -> AnyPublisher<ResponseSeriesPopulares, ApiError> {
        let parameters: [String: Any] = [
            "page": self.page
        ]
        let request = CommonData.obtainRequest(withEndPoint: "tv/popular", parameters: parameters)
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let urlResponse = response as? HTTPURLResponse, 200..<300 ~= urlResponse.statusCode else {
                    throw ApiError.respuestaInvalida
                }
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("➡️ JSON Recibido (Series): \(jsonString)")
                }
                self.page = self.page + 1
                return data
            }
            .decode(type: ResponseSeriesPopulares.self, decoder: jsonDecoder)
            .mapError { (error) -> ApiError in
                return self.handleSeriesError(error)
            }
            .eraseToAnyPublisher()
    }
    
    /**func obtenerDetalleSeries(idSerie: String) -> AnyPublisher<ResponseDetallesSerie, ApiError> {
        let request = CommonData.obtainRequest(withEndPoint: "tv/\(idSerie)")
        return ApiError.invalidURL
    }**/
    
}
