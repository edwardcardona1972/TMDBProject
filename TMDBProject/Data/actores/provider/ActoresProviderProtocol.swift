//
//  ActoresProviderProtocol.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 8/5/25.
//
import Foundation
import Combine

protocol ActoresProviderProtocol {
    func obtenerActoresPopulares() -> AnyPublisher<ResponseActoresPopulares, ApiError>
    
    func obtenerActorDetalle(idActor: String) -> AnyPublisher<ResponseDetallesActor, ApiError>
}
