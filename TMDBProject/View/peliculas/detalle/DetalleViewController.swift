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
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var adult: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var overView: UITextView!
   
    var emojiSequences = ["😀 😍 🥱", "😍 🥱 😀", "🥱 😀 😍"]
    var currentEmojiIndex = 0
    var idPelicula : Int = 0
    var cancellables: Set<AnyCancellable> = []
    var viewModel: DetailsViewModel = DetailsViewModel(peliculasProviderProtocol: PeliculasProviderNetwork())
    var isAnimatingEmojis = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voteAverage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleVoteAverageTap))
        voteAverage.addGestureRecognizer(tapGesture)
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
                }
            } receiveValue: { _ in
                guard let details = self.viewModel.detallePelicula else { return }
                self.movieTitle.text = details.title
                if let firstCountryCode = details.origin_country.first {
                    if let countryName = Locale.current.localizedString(forRegionCode: firstCountryCode!) {
                        self.originContry.text = "Country of Origin: \(countryName)"
                    } else {
                        self.originContry.text = "Country of Origin: \(String(describing: firstCountryCode))"
                    }
                } else {
                    self.originContry.text = "País de origen: N/A"
                }
                self.voteAverage.text = "User rating 😀😍🥱 : (\(details.vote_average))"
                self.revenue.text = "Revenue: \(details.revenue ?? 0)"
                self.budget.text = "Budget: \(details.budget ?? 0)"
                self.popularity.text = "Popularity: \(details.popularity ?? 0)"
                self.adult.text = "Adult: \(details.adult ? "Yes" : "No")"
                
                self.overView.text = details.overview ?? "No description available"
                
                if let releaseDateString = details.release_date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = dateFormatter.date(from: releaseDateString) {
                        let yearFormatter = DateFormatter()
                        yearFormatter.dateFormat = "dd MMMM yyyy"
                        self.releaseDate.text = yearFormatter.string(from: date)
                    } else {
                        self.releaseDate.text = "N/A"
                        print("Warning: Could not parse release date string: \(releaseDateString)")
                    }
                } else {
                    self.releaseDate.text = "N/A"
                }
                if let poster_path = details.poster_path {
                    self.loadImage(posterPath: poster_path)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func handleVoteAverageTap() {
        if !isAnimatingEmojis {
            isAnimatingEmojis = true
            animateVoteEmojis()
        }
    }
    
    func animateVoteEmojis() {
        UIView.transition(with: self.voteAverage,
                          duration: 0.5,
                          options: .curveEaseInOut,
                          animations: {
            let currentEmojis = self.emojiSequences[self.currentEmojiIndex]
            self.voteAverage.text = "User rating\(currentEmojis): (\(String(describing: self.viewModel.detallePelicula?.vote_average ?? 0)))"
            self.currentEmojiIndex = (self.currentEmojiIndex + 1) % self.emojiSequences.count
        },
                          completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.isAnimatingEmojis = false
            }
        })
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
