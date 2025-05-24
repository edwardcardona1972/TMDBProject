//
//  ActorDetalleViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/5/25.
//

import UIKit
import Combine

class ActorDetalleViewController: UIViewController {

    @IBOutlet weak var imagenActor: UIImageView!
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var actorBiography: UITextView!
    @IBOutlet weak var actorKnownFor: UILabel!
    @IBOutlet weak var actorPopularity: UILabel!
    
    var idActor: Int = 0
    var cancellables: Set<AnyCancellable> = []
    var viewModel: ActorDetallesViewModel = ActorDetallesViewModel(actoresProviderProtocol: ActoresProviderNetwork())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscription()
        viewModel.getActorDetalles(idActor: String(idActor))
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
                guard let actorDetalle = self.viewModel.actorDetalles else { return }
                
                if let poster_path = actorDetalle.profile_path {
                    self.loadImage(posterPath: poster_path)
                }
                
                self.actorName.text = actorDetalle.name
                self.actorBiography.text = actorDetalle.biography
                
                if actorDetalle.also_known_as.isEmpty {
                    self.actorKnownFor.text = "N/A"
                }else{
                    self.actorKnownFor.text = actorDetalle.also_known_as.joined(separator: ", ")
                }
                
                self.actorPopularity.text = String(actorDetalle.popularity)
                
                
                
                
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
                self.imagenActor.image = UIImage(data: imageData)
            }
        }.resume()
    }

}
