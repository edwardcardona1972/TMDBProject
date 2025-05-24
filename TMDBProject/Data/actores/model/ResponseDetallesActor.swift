//
//  DetallesActor.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/5/25.
//

import Foundation

struct ResponseDetallesActor: Decodable {
    let id : Int
    let name: String
    let profile_path: String?
    let also_known_as: [String]
    let biography: String
    let popularity: Double
}
