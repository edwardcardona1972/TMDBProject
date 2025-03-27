//
//  ListaViewModel.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//

import Foundation
import Combine
class ListaViewModel {
    
    var peliculasProviderProtocol: PeliculasProviderProtocol
    var peliculas: [Pelicula] = []
    var reloadData = PassthroughSubject<Void, Error>()
    init(peliculasProviderProtocol: PeliculasProviderProtocol) {
        self.peliculasProviderProtocol = peliculasProviderProtocol
    }
    
    func getPeliculas(){
        let listaPeliculas = peliculasProviderProtocol.getPeliculas()
        peliculas = listaPeliculas.results
        reloadData.send(())
    }
}
