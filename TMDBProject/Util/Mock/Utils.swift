//
//  Utils.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 26/3/25.
//
import Foundation

class Utils {
    static func parseJson<T: Decodable>(jsonName : String, model: T.Type) -> T?{
        guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}
