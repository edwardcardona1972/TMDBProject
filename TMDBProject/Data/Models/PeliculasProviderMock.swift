//
//  PeliculasProviderMock.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//

import Combine
import Foundation

class PeliculasProviderMock : PeliculasProviderProtocol {
    func getPeliculas() -> AnyPublisher<ResponseMasPopulares, Error> {
        let model = Utils.parseJson(jsonName: "maspopulares", model: ResponseMasPopulares.self) ?? ResponseMasPopulares(page: 0, results: [])
        return Just(model)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
