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
    var peliculas: [Pelicula] = []
    var reloadData = PassthroughSubject<Void, Error>()
    var anyCancellable: Set<AnyCancellable> = []
    weak var delegate: ListaViewModelDelegate?
    private var imageCache: [String: UIImage] = [:]
    
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
    
    func loadImage(posterPath: String, at indexPath: IndexPath) {
        if let cachedImage = imageCache[posterPath] {
            delegate?.didLoadImage(image: cachedImage, at: indexPath)
            return
        }
        guard let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self, let image = image else { return }
                self.imageCache[posterPath] = image
                self.delegate?.didLoadImage(image: image, at: indexPath)
            }
            .store(in: &anyCancellable)
    }
}
