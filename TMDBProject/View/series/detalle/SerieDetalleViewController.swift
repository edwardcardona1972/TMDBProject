//
//  SerieDetalleViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/5/25.
//

import UIKit
import Combine

class SerieDetalleViewController: UIViewController {

    @IBOutlet weak var imagenSerie: UIImageView!
    @IBOutlet weak var serieNombre: UILabel!
    @IBOutlet weak var serieNombreOriginal: UILabel!
    
    @IBOutlet weak var serieOverview: UITextView!
    @IBOutlet weak var serieFechaInicio: UILabel!
    @IBOutlet weak var serieLenguageOriginal: UILabel!
    
    var idSerie: Int = 0
    var serieDetallesViewModel: SerieDetallesViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serieDetallesViewModel = SerieDetallesViewModel(seriesProviderProtocol: SeriesProviderNetwork())
        subscription()
        serieDetallesViewModel.getSerieDetalles(idSerie: String(idSerie))
    }
    
    func subscription() {
        serieDetallesViewModel.reloadData.sink{ completition in
            switch completition {
                case .finished:
                    print("Finished loading details")
                case .failure(let error):
                    print("Error loading details: \(error)")
            }
        } receiveValue: { _ in
            guard let details = self.serieDetallesViewModel.serieDetalles else { return }
            if let poster_path = details.poster_path {
                self.loadImage(posterPath: poster_path)
            }
            
            self.serieNombre.text = details.name
            self.serieNombreOriginal.text = details.original_name
            
            self.serieOverview.text = details.overview ?? "No description available"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: details.first_air_date) {
                let yearFormatter = DateFormatter()
                yearFormatter.dateFormat = "dd MMMM yyyy"
                self.serieFechaInicio.text = yearFormatter.string(from: date)
            } else {
                print("Warning: Could not parse release date: \(details.first_air_date)")
                self.serieFechaInicio.text = "N/A"
            }
            
            if let originalLanguage = details.original_language {
                self.serieLenguageOriginal.text = originalLanguage
            } else {
                self.serieLenguageOriginal.text = "Original language not found"
            }
            
            
        
            
        }.store(in: &cancellables)
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
                self.imagenSerie.image = UIImage(data: imageData)
            }
        }.resume()
    }

}
