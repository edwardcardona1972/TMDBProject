//
//  PeliculasProviderNetwork.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 31/3/25.
//

import Foundation
import Combine

class PeliculasProviderNetwork: PeliculasProviderProtocol {
    
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    private var pagina = 1
    
    private func handlePeliculasError(_ error: Error) -> ApiError {
        if let peliculaError = error as? ApiError {
            return peliculaError
        } else if let decodingError = error as? DecodingError {
            print("🔴 Error de decodificación en Buscar Películas: \(decodingError)")
            return ApiError.apiError
        } else {
            return ApiError.apiError
        }
    }
    
    func obtenerPeliculas() -> AnyPublisher<ResponsePeliculasPopulares, ApiError> {
        let parameters: [String: Any] = [
            "page": self.pagina
        ]
        let request = CommonData.obtainRequest(withEndPoint: "movie/popular", parameters: parameters)
        
        return urlSession.dataTaskPublisher(for: request).tryMap { data, response in
            guard let urlResponse = response as? HTTPURLResponse, 200..<300 ~= urlResponse.statusCode else {
                throw ApiError.respuestaInvalida
            }
            self.pagina = self.pagina + 1
            return data
        }
        .decode(type: ResponsePeliculasPopulares.self, decoder: jsonDecoder)
        .mapError { (error) -> ApiError in
            return self.handlePeliculasError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getDetallesPelicula(peliculaId: String) -> AnyPublisher<ResponseDetallesPelicula, ApiError> {
        let request = CommonData.obtainRequest(withEndPoint: "movie/\(peliculaId)")
        
        return urlSession.dataTaskPublisher(for: request).tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw ApiError.respuestaInvalida
                }
                return data
            }
            .decode(type: ResponseDetallesPelicula.self, decoder: JSONDecoder()) 
            .mapError(handlePeliculasError)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        }
    
    func buscarPeliculas(query: String) -> AnyPublisher<ResponsePeliculasPopulares, ApiError> {
        let parameters: [String: Any] = [
            "query": query
        ]
        let request = CommonData.obtainRequest(withEndPoint: "search/movie", parameters: parameters)
        return urlSession.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw ApiError.respuestaInvalida
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("➡️ JSON Recibido (Buscar Películas): \(jsonString)")
            }
            return data
        }
        .decode(type: ResponsePeliculasPopulares.self, decoder: jsonDecoder)
        .mapError(handlePeliculasError)
        .eraseToAnyPublisher()
    }
}
