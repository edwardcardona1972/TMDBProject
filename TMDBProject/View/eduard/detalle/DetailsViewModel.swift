//
//  DetailsViewModel.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 2/4/25.
//

import Foundation
import Combine

class DetailsViewModel: ObservableObject {
    
    var peliculasProviderProtocol: PeliculasProviderProtocol
    @Published var detallePelicula: ResponseDetallesPelicula?
    var reloadData = PassthroughSubject<Void, Error>()
    
    init(peliculasProviderProtocol: PeliculasProviderProtocol) {
        self.peliculasProviderProtocol = peliculasProviderProtocol
    }
    
    func getDetallesPelicula(peliculaId: String) {
        peliculasProviderProtocol.getDetallesPelicula(peliculaId: peliculaId){ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.detallePelicula = response
                self.reloadData.send(())
            case .failure(let error):
                print(error.descripcion)
                reloadData.send(completion: .failure(error))
            }
        }
    }
}
