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
    var peliculasProviderProtocol: PeliculasProviderProtocol
    @Published var peliculas: [Pelicula] = []
    private var imageCache: [String: UIImage] = [:]
    private var anyCancellable: Set<AnyCancellable> = []
    let imageLoadedPublisher = PassthroughSubject<(UIImage?, IndexPath), Never>()
    
    init(peliculasProviderProtocol: PeliculasProviderProtocol) {
        self.peliculasProviderProtocol = peliculasProviderProtocol
    }
    
    func getPeliculas(pagina: String) {
        peliculasProviderProtocol.getPeliculas(page: pagina)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.descripcion)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.peliculas.append(contentsOf: response.results)
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
