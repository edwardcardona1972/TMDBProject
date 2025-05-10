//
//  HomeViewModel.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 30/4/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var listaDeActores: [Actor] = []
    @Published var listaDeSeries: [Serie] = []
    @Published var listaDePeliculas: [Pelicula] = []  
    
    private let actoresProvider: ActoresProviderProtocol
    private let seriesProvider: SeriesProviderProtocol
    private let peliculasProvider: PeliculasProviderProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(actoresProvider: ActoresProviderProtocol, seriesProvider: SeriesProviderProtocol, peliculasProvider: PeliculasProviderProtocol) {
        self.actoresProvider = actoresProvider
        self.seriesProvider = seriesProvider
        self.peliculasProvider = peliculasProvider
        
        obtenerActoresPopulares()
        obtenerSeriesPopulares()
        obtenerPeliculasPopulares()
    }
    
    private func obtenerActoresPopulares() {
        actoresProvider.obtenerActoresPopulares(pagina: "1")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error en ViewModel al obtener actores: \(error)")
                }
            }, receiveValue: { [weak self] response in
                print("Actores recibidos: \(response)")
                self?.listaDeActores = response.results
                print("Lista de actores actualizada: \(self?.listaDeActores ?? [])")
            })
            .store(in: &cancellables)
    }
    
    private func obtenerSeriesPopulares() {
        seriesProvider.obtenerSeriesPopulares(pagina: "1")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error en ViewModel al obtener series: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.listaDeSeries = response.results
            })
            .store(in: &cancellables)
    }
    
    private func obtenerPeliculasPopulares() {
        peliculasProvider.obtenerPeliculas(page: "1")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error en ViewModel al obtener películas: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.listaDePeliculas = response.results
            })
            .store(in: &cancellables)
    }

}
