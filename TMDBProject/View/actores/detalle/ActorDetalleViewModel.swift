//
//  ActorDetalleViewModel.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/5/25.
//

import Foundation
import Combine

class ActorDetallesViewModel {
    
    var actoresProviderProtocol: ActoresProviderProtocol
    var actorDetalles: ResponseDetallesActor?
    var reloadData = PassthroughSubject<Void, Error>()
    var anyCancellables: Set<AnyCancellable> = []
    
    init(actoresProviderProtocol: ActoresProviderProtocol) {
        self.actoresProviderProtocol = actoresProviderProtocol
    }
    
    func getActorDetalles(idActor: String) {
        actoresProviderProtocol.obtenerActorDetalle(idActor: idActor)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.reloadData.send(completion: .failure(error))
                case .finished:
                    break
                }
            }, receiveValue: {response in
                self.actorDetalles = response
                self.reloadData.send(())
            })
            .store(in: &anyCancellables)
    }
}
