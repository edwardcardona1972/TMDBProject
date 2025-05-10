//
//  ListaViewModel.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//
import UIKit
import Combine
import Foundation

class ListaViewModel {
    let peliculasProviderProtocol: PeliculasProviderProtocol
    @Published var peliculas: [Pelicula] = []
    @Published var searchValue: String = ""
    @Published var filteredPeliculas: [Pelicula] = []
    private var imageCache: [String: UIImage] = [:]
    private var anyCancellable: Set<AnyCancellable> = []
    let imageLoadedPublisher = PassthroughSubject<(UIImage?, IndexPath), Never>()
    
    init(peliculasProviderProtocol: PeliculasProviderProtocol) {
        self.peliculasProviderProtocol = peliculasProviderProtocol
        $searchValue
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterPeliculas(searchText: searchText)
            }
            .store(in: &anyCancellable)
    }
    
    func getPeliculas(pagina: String) {
        peliculasProviderProtocol.obtenerPeliculas(page: pagina)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener películas (página \(pagina)): \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                // Aquí debes actualizar la propiedad 'peliculas'
                self.peliculas.append(contentsOf: response.results)
                self.filterPeliculas(searchText: self.searchValue)
            })
            .store(in: &anyCancellable)
    }
    
    private func filterPeliculas(searchText: String) {
        if searchText.isEmpty {
            filteredPeliculas = peliculas
        } else {
            filteredPeliculas = peliculas.filter { pelicula in
                pelicula.title.localizedCaseInsensitiveContains(searchText) ||
                pelicula.overview.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func buscarPeliculas(query: String) {
        peliculas = []
        peliculasProviderProtocol.buscarPeliculas(query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error al buscar películas: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.peliculas = response.results
                self.filterPeliculas(searchText: query)
            })
            .store(in: &anyCancellable)
    }
    
    func loadImage(from urlString: String?, at indexPath: IndexPath) {
        guard let urlString = urlString, !urlString.isEmpty else {
            imageLoadedPublisher.send((UIImage(named: "placeholder"), indexPath))
            return
        }
        
        if let cachedImage = imageCache[urlString] {
            imageLoadedPublisher.send((cachedImage, indexPath))
            return
        }
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(urlString)") {
            URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: UIImage(named: "placeholder"))
                .receive(on: DispatchQueue.main)
                .sink { [weak self] image in
                    guard let self = self else { return }
                    let optionalUrlString: String? = urlString
                    if let unwrappedUrlString = optionalUrlString, let validImage = image, validImage != UIImage(named: "placeholder") {
                        self.imageCache[unwrappedUrlString] = validImage
                    }
                    self.imageLoadedPublisher.send((image, indexPath))
                }
                .store(in: &anyCancellable)
        } else {
            imageLoadedPublisher.send((UIImage(named: "placeholder"), indexPath))
        }
    }
}
