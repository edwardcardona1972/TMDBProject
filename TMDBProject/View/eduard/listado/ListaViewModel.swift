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
    var anyPublisher: Set<AnyCancellable> = []
    
    init(peliculasProviderProtocol: PeliculasProviderProtocol) {
        self.peliculasProviderProtocol = peliculasProviderProtocol
    }
    
    func getPeliculas(){
        peliculasProviderProtocol.getPeliculas().sink { (completion) in
            print("Completion: \(completion)")
        } receiveValue: { (peliculas) in
            self.peliculas = peliculas.results
            self.reloadData.send(())
        }.store(in: &anyPublisher)
    }
}
