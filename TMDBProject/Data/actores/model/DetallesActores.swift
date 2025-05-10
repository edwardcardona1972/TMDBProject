//
//  DetallesActores.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 29/4/25.

import Foundation

struct ResponseActoresPopulares: Decodable {
    let page: Int
    let results: [Actor]
    let total_pages: Int
    let total_results: Int
}

struct Actor: Decodable {
    let adult: Bool?
    let gender: Int?
    let id: Int
    let known_for: [KnownForPopular]?
    let known_for_department: String?
    let name: String
    let popularity: Double?
    let profile_path: String
}
struct KnownForPopular: Decodable {
    let original_title: String?
    let overview: String?
    let release_date: String?
    let poster_path: String?
}

