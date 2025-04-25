//
//  TableViewCell2.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 9/4/25.
//
import UIKit
import Combine

class TableViewCell2: UITableViewCell {
    @IBOutlet weak var imagenPelicula: UIImageView!
    @IBOutlet weak var titulosPelicula: UILabel!
    @IBOutlet weak var fechaEstreno: UILabel!
    @IBOutlet weak var detallesPelicula: UILabel!
    
    private var cancellable: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagenPelicula.image = UIImage(named: "placeholder")
        cancellable?.cancel()
        cancellable = nil
    }
    
    func configure(with pelicula: Pelicula, viewModel: ListaViewModel, indexPath: IndexPath) {
        imagenPelicula.image = UIImage(named: "placeholder")
        cancellable = viewModel.imageLoadedPublisher
            .receive(on: DispatchQueue.main)
            .filter { $0.1 == indexPath }
            .sink { [weak self] (image, indexPath) in
                self?.imagenPelicula.image = image ?? UIImage(named: "placeholder")
            }
        viewModel.loadImage(from: pelicula.poster_path, at: indexPath)
        fechaEstreno.text = pelicula.release_date
    }
}
