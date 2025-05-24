//
//  DetallesSeries.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 29/4/25.
//

import Foundation
struct ResponseSeriesPopulares: Decodable {
    let page: Int
    let results: [Serie]
    let total_pages: Int
    let total_results: Int
}

struct Serie: Decodable {
    let backdrop_path: String?
    let first_air_date: String?
    let genre_ids: [Int]?
    let id: Int
    let name: String?
    let origin_country: [String]?
    let original_language: String?
    let original_name: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let vote_average: Double?
    let vote_count: Int?
}
