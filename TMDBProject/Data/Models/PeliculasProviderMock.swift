//
//  PeliculasProviderMock.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//

class PeliculasProviderMock : PeliculasProviderProtocol {
    func getPeliculas() async -> ResponseMasPopulares {
        let model = Utils.parseJson(jsonName: "maspopulares", model: ResponseMasPopulares.self) ?? ResponseMasPopulares(page: 0, results: [])
        return model
    }
}
