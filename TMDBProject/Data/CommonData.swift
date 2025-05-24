//
//  CommonData.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/5/25.
//
import Foundation

struct CommonData {
    static let API_END_POINT = "https://api.themoviedb.org/3/"
    static let BEARER_TOKEN = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMGViNDVjMDkyMTcxMGY2NDc1NTRjMzM2NjI4YTZmYSIsIm5iZiI6MTc0MjgzMzE0OS4zNjgsInN1YiI6IjY3ZTE4NWZkMzViZDI2YTdkOTRkZGJiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.JXDIZ0RRxUHzoGkN2n9fr85zmhSwc9nRmlyTSCSST-Y"
    
    static func obtainRequest(withEndPoint endPoint: String, parameters: [String: Any]? = nil) -> URLRequest {
        let url = URL(string: "\(CommonData.API_END_POINT)\(endPoint)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "es-ES"),
        ]
        
        if let parameters = parameters {
            let requestParams = parameters.compactMap { (key, value) in
                return URLQueryItem(name: key, value: "\(value)")
            }
            queryItems.append(contentsOf: requestParams)
        }
        
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": CommonData.BEARER_TOKEN
        ]
        return request
    }
}
