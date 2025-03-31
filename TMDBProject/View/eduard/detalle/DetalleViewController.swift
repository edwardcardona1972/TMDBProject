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
        title = pelicula.title
        descripcion.text = pelicula.overview
    }
}
