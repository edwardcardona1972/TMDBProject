//
//  PeliculasProviderMock.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//

import Combine
import Foundation

class PeliculasProviderMock : PeliculasProviderProtocol {
    func getPeliculas(page: String, completed: @escaping (Result<ResponseMasPopulares, PeliculaError>) -> ()){
        let model = Utils.parseJson(jsonName: "maspopulares", model: ResponseMasPopulares.self) ?? ResponseMasPopulares(page: 0, results: [])
        completed(Result.success(model))
    }
}
