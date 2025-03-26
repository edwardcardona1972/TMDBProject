//
//  Pelicula.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//

struct ResponseMasPopulares: Decodable {
    let page: Int
    let results: [Pelicula]
}
struct Pelicula: Decodable {
    let adult: Bool
    let ´genere_ids´:[Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
}
