//
//  DetailsViewModel.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 2/4/25.
//

import Foundation
import Combine

class DetailsViewModel {
    
    var peliculasProviderProtocol: PeliculasProviderProtocol
    var detallePelicula: ResponseDetallesPelicula?
    var reloadData = PassthroughSubject<Void, Error>()
    var anyCancellables: Set<AnyCancellable> = []
    
    init(peliculasProviderProtocol: PeliculasProviderProtocol) {
        self.peliculasProviderProtocol = peliculasProviderProtocol
    }
    
    func getDetallesPelicula(peliculaId: String) {
        peliculasProviderProtocol.getDetallesPelicula(peliculaId: peliculaId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.reloadData.send(completion: .failure(error))
                case .finished:
                    break
                }
            }, receiveValue: {response in
                self.detallePelicula = response
                self.reloadData.send(())
            })
            .store(in: &anyCancellables)
    }
}
