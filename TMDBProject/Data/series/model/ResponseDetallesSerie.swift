//
//  ResponseDetallesSerie.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/5/25.
//

import Foundation

struct ResponseDetallesSerie: Decodable {
    let id: Int
    let original_language: String?
    let name: String
    let original_name: String?
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let first_air_date: String
    let last_air_date: String
    let status: String
    let vote_average: Double
}
