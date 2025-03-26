//
//  CharacterDataSource.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/3/25.
//

import UIKit
import Alamofire

class PeliculasDataSource: NSObject, ObservableObject {
    
    
    
    static let nowPlaying = "https://api.themoviedb.org/3/movie/now_playing?api_key=bbf4ee605b49ebabf960545fbfbb1e0a&language=es-MX&page="
    private let KStatusOK = 200...299
    private static let publicKey = "f0eb45c0921710f647554c336628a6fa"
    private static let baseURL = "https://api.themoviedb.org/3/movie/11"
    
    
    func cargarPeliculasPorNombre(nombre: String) -> [Pelicula] {
        
        return []
    }
}
