//
//  Pelicula.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//

struct ResponseDetallesPelicula: Decodable {
    let adult: Bool
    let backdrop_path: String?
    let belongs_to_collection: String?
    let budget: Int?
    let genres: [Genre?]
    let homepage: String?
    let id: Int?
    let imdb_id: String?
    let origin_country: [String?]
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let vote_average: Double
    let vote_count: Int?
}

struct Genre: Decodable {
    let id: Int?
    let name: String?
}

struct ProductionCompany: Decodable {
    let id: Int?
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

struct SpokenLanguage: Decodable {
    let english_name: String?
    let iso_639_1: String?
    let name: String?
}
