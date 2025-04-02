//
//  PeliculasProviderNetwork.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 31/3/25.
//

import Foundation

class PeliculasProviderNetwork: PeliculasProviderProtocol {
    
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func getPeliculas(page:String, completed: @escaping (Result<ResponseMasPopulares, PeliculaError>) -> ()) {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: page),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMGViNDVjMDkyMTcxMGY2NDc1NTRjMzM2NjI4YTZmYSIsIm5iZiI6MTc0MjgzMzE0OS4zNjgsInN1YiI6IjY3ZTE4NWZkMzViZDI2YTdkOTRkZGJiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JXDIZ0RRxUHzoGkN2n9fr85zmhSwc9nRmlyTSCSST-Y"
        ]
        
        urlSession.dataTask(with: request){ [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil {
                self.ejecutarCompletionHandlerHiloPrincipal(with: .failure(.apiError), completed: completed)
                return
            }
            guard let urlResponse = response as? HTTPURLResponse, 200..<300 ~= urlResponse.statusCode else {
                self.ejecutarCompletionHandlerHiloPrincipal(with: .failure(.respuestaInvalida), completed: completed)
                return
            }
            do {
                let responseMasPopulares = try self.jsonDecoder.decode(ResponseMasPopulares.self, from: data ?? Data())
                self.ejecutarCompletionHandlerHiloPrincipal(with: .success(responseMasPopulares), completed: completed)
            } catch {
                self.ejecutarCompletionHandlerHiloPrincipal(with: .failure(.respuestaInvalida), completed: completed)
            }
        }.resume()
    }
    
    private func ejecutarCompletionHandlerHiloPrincipal<D: Decodable>(with result: Result<D, PeliculaError>, completed: @escaping (Result<D, PeliculaError>) -> ()) {
        DispatchQueue.main.async {
            completed(result)
        }
    }
    
    func getDetallesPelicula(peliculaId: String, completed: @escaping (Result<ResponseDetallesPelicula, PeliculaError>) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(peliculaId)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMGViNDVjMDkyMTcxMGY2NDc1NTRjMzM2NjI4YTZmYSIsIm5iZiI6MTc0MjgzMzE0OS4zNjgsInN1YiI6IjY3ZTE4NWZkMzViZDI2YTdkOTRkZGJiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JXDIZ0RRxUHzoGkN2n9fr85zmhSwc9nRmlyTSCSST-Y"
        ]
        
        urlSession.dataTask(with: request){ [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil {
                self.ejecutarCompletionHandlerHiloPrincipal(with: .failure(.apiError), completed: completed)

                return
            }
            guard let urlResponse = response as? HTTPURLResponse, 200..<300 ~= urlResponse.statusCode else {
                self.ejecutarCompletionHandlerHiloPrincipal(with: .failure(.respuestaInvalida), completed: completed)
                return
            }
            do {
                let detallePelicula = try self.jsonDecoder.decode(ResponseDetallesPelicula.self, from: data ?? Data())
                self.ejecutarCompletionHandlerHiloPrincipal(with: .success(detallePelicula), completed: completed)
            } catch {
                self.ejecutarCompletionHandlerHiloPrincipal(with: .failure(.respuestaInvalida), completed: completed)
            }
        }.resume()
    }
}
