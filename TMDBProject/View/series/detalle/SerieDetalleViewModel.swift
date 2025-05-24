//
//  SerieDetalleViewModel.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/5/21234.Abc

import Foundation
import Combine

class SerieDetallesViewModel {
    
    var seriesProviderProtocol: SeriesProviderProtocol
    var serieDetalles: ResponseDetallesSerie?
    var reloadData = PassthroughSubject<Void, Error>()
    var anyCancellables: Set<AnyCancellable> = []
    
    init(seriesProviderProtocol: SeriesProviderProtocol) {
        self.seriesProviderProtocol = seriesProviderProtocol
    }
    
    func getSerieDetalles(idSerie: String) {
        seriesProviderProtocol.obtenerDetalleSeries(idSerie: idSerie)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.reloadData.send(completion: .failure(error))
                case .finished:
                    break
                }
            }, receiveValue: {response in
                self.serieDetalles = response
                self.reloadData.send(())
            })
            .store(in: &anyCancellables)
    }
}
