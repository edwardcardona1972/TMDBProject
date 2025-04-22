//
//  DetalleViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 27/3/25.
//

import UIKit
import Combine

class DetalleViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var originContry: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var adult: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    var idPelicula : Int = 0
    var cancellables: Set<AnyCancellable> = []
    var viewModel: DetailsViewModel = DetailsViewModel(peliculasProviderProtocol: PeliculasProviderNetwork())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscription()
        viewModel.getDetallesPelicula(peliculaId: String(idPelicula))
    }
    
    func subscription() {
        viewModel.reloadData
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished loading details")
                case .failure(let error):
                    print("Error loading details: \(error)")
                    // Handle the error appropriately, e.g., show an alert
                }
            } receiveValue: { _ in
                guard let details = self.viewModel.detallePelicula else { return }
                self.movieTitle.text = details.title
                if let firstCountry = details.origin_country.first {
                    self.originContry.text = firstCountry
                } else {
                    self.originContry.text = "N/A"
                }
                self.budget.text = "Budget: \(details.budget ?? 0)"
                self.revenue.text = "Revenue: \(details.revenue ?? 0)"
                self.popularity.text = "Popularity: \(details.popularity ?? 0)"
                self.adult.text = "Adult: \(details.adult ? "Yes" : "No")"
                
                if let poster_path = details.poster_path {
                    self.loadImage(posterPath: poster_path)
                }
            }
            .store(in: &cancellables)
    }
    func loadImage(posterPath: String) {
        let urlString = "https://image.tmdb.org/t/p/w500/\(posterPath)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            guard let imageData = data else {
                print("No image data received.")
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }.resume()
    }
}
