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
    var anyCancellable: Set<AnyCancellable> = []
    
    init(peliculasProviderProtocol: PeliculasProviderProtocol) {
        self.peliculasProviderProtocol = peliculasProviderProtocol
    }
    
    func getPeliculas(pagina: String) {
        peliculasProviderProtocol.getPeliculas(page: pagina).sink(receiveCompletion: {completion in
            switch completion {
            case .failure(let error):
                print(error.descripcion)
                self.reloadData.send(completion: .failure(error))
            case .finished:
                break
            }
        }, receiveValue: {response in
            self.peliculas.append(contentsOf: response.results)
            self.reloadData.send(())
        })
        .store(in: &anyCancellable)
    }
}
