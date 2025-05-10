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
    
    func obtenerPeliculas(page: String) -> AnyPublisher<ResponsePeliculasPopulares, ApiError> {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "es-ES"),
            URLQueryItem(name: "page", value: page),
        ]
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMGViNDVjMDkyMTcxMGY2NDc1NTRjMzM2NjI4YTZmYSIsIm5iZiI6MTc0MjgzMzE0OS4zNjgsInN1YiI6IjY3ZTE4NWZkMzViZDI2YTdkOTRkZGJiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JXDIZ0RRxUHzoGkN2n9fr85zmhSwc9nRmlyTSCSST-Y"
        ]
        return urlSession.dataTaskPublisher(for: request).tryMap { data, response in
                guard let urlResponse = response as? HTTPURLResponse, 200..<300 ~= urlResponse.statusCode else {
                    throw ApiError.respuestaInvalida
                }
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
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(peliculaId)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "es-ES")
        ]
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMGViNDVjMDkyMTcxMGY2NDc1NTRjMzM2NjI4YTZmYSIsIm5iZiI6MTc0MjgzMzE0OS4zNjgsInN1YiI6IjY3ZTE4NWZkMzViZDI2YTdkOTRkZGJiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JXDIZ0RRxUHzoGkN2n9fr85zmhSwc9nRmlyTSCSST-Y"
        ]
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
        let url = URL(string: "https://api.themoviedb.org/3/search/movie")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "es-ES"),
            URLQueryItem(name: "query", value: query)
        ]
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMGViNDVjMDkyMTcxMGY2NDc1NTRjMzM2NjI4YTZmYSIsIm5iZiI6MTc0MjgzMzE0OS4zNjgsInN1YiI6IjY3ZTE4NWZkMzViZDI2YTdkOTRkZGJiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JXDIZ0RRxUHzoGkN2n9fr85zmhSwc9nRmlyTSCSST-Y"
        ]
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
