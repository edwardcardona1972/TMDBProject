//
//  DetalleViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 27/3/25.
//

import UIKit

class DetalleViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcion: UITextView!
    var pelicula: Pelicula?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension DetalleViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let pelicula = pelicula else { return }
        descripcion.text = pelicula.overview
        
        let url = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w500/" + (pelicula.poster_path))!)
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
