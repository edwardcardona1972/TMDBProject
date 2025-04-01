//
//  ListaViewModel.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//
import Foundation
import Combine
class ListaViewModel: ObservableObject {
    
    var peliculasProviderProtocol: PeliculasProviderProtocol
    var peliculas: [Pelicula] = []
    var reloadData = PassthroughSubject<Void, Error>()
    var anyPublisher: Set<AnyCancellable> = []
    
    init(peliculasProviderProtocol: PeliculasProviderProtocol) {
        self.peliculasProviderProtocol = peliculasProviderProtocol
    }
    
    func getPeliculas(pagina: String) {
        peliculasProviderProtocol.getPeliculas(page: pagina){ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.peliculas.append(contentsOf: response.results) 
                self.reloadData.send(())
            case .failure(let error):
                print(error.descripcion)
                reloadData.send(completion: .failure(error))
            }
        }
    }
}
