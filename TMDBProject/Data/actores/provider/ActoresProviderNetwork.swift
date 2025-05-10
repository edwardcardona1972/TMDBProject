//
//  ActorProviderNetwork.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 1/5/25.
//

import Foundation
import Combine

class ActoresProviderNetwork: ActoresProviderProtocol {
    
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    private func handleActoresError(_ error: Error) -> ApiError {
        if let peliculaError = error as? ApiError {
            return peliculaError
        } else if let decodingError = error as? DecodingError {
            print("🔴 Error de decodificación en Actores: \(decodingError)")
            return ApiError.apiError
        } else {
            print("⚠️ Otro tipo de error en Actores: \(error.localizedDescription)")
            return ApiError.apiError
        }
    }
    
    func obtenerActoresPopulares(pagina: String) -> AnyPublisher<ResponseActoresPopulares, ApiError> {
        let url = URL(string: "https://api.themoviedb.org/3/person/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "es-ES"),
            URLQueryItem(name: "page", value: pagina),
        ]
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMGViNDVjMDkyMTcxMGY2NDc1NTRjMzM2NjI4YTZmYSIsIm5iZiI6MTc0MjgzMzE0OS4zNjgsInN1YiI6IjY3ZTE4NWZkMzViZDI2YTdkOTRkZGJiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JXDIZ0RRxUHzoGkN2n9fr85zmhSwc9nRmlyTSCSST-Y"
        ]
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let urlResponse = response as? HTTPURLResponse, 200..<300 ~= urlResponse.statusCode else {
                    throw ApiError.respuestaInvalida
                }
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("➡️ JSON Recibido (Actores): \(jsonString)")
                }
                return data
            }
            .decode(type: ResponseActoresPopulares.self, decoder: jsonDecoder)
            .mapError { (error) -> ApiError in
                return self.handleActoresError(error)
            }
            .eraseToAnyPublisher()
    }
}

