//
//  TableViewCellPelicula.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 9/4/25.
//
import UIKit
import Combine

class TableViewCellPelicula: UITableViewCell {
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
        cancellable?.cancel()
        cancellable = nil
    }
    
    func configure(pelicula: Pelicula) {
        titulosPelicula.text = pelicula.title
        fechaEstreno.text = pelicula.release_date
        detallesPelicula.text = pelicula.overview
        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w200\(pelicula.poster_path)")!
        cancellable = URLSession.shared.dataTaskPublisher(for: imageUrl)
            .receive(on: DispatchQueue.main)
            .map { UIImage(data: $0.data) }
            .sink(receiveCompletion: { completion in
            }, receiveValue: { [weak self] image in
                self?.imagenPelicula.image = image
            })
    }
}
