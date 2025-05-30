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
    private var page = 1
    
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
    
    func obtenerActoresPopulares() -> AnyPublisher<ResponseActoresPopulares, ApiError> {
        let parameters: [String: Any] = [
            "page": self.page
        ]
        let request = CommonData.obtainRequest(withEndPoint: "person/popular", parameters: parameters)
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let urlResponse = response as? HTTPURLResponse, 200..<300 ~= urlResponse.statusCode else {
                    throw ApiError.respuestaInvalida
                }
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("➡️ JSON Recibido (Actores): \(jsonString)")
                }
                self.page = self.page + 1
                return data
            }
            .decode(type: ResponseActoresPopulares.self, decoder: jsonDecoder)
            .mapError { (error) -> ApiError in
                return self.handleActoresError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func obtenerActorDetalle(idActor: String) -> AnyPublisher<ResponseDetallesActor, ApiError> {
        let request = CommonData.obtainRequest(withEndPoint: "person/\(idActor)")
        return urlSession.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw ApiError.respuestaInvalida
            }
            return data
        }
        .decode(type: ResponseDetallesActor.self, decoder: JSONDecoder())
        .mapError(handleActoresError)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
