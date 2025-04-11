//
//  TableViewCell2.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 9/4/25.
//
import UIKit
protocol TableViewCell2Delegate: AnyObject {
    func didStartLoadingImage(in index: IndexPath)
}

class TableViewCell2: UITableViewCell {
    @IBOutlet weak var imagenPelicula: UIImageView!
    @IBOutlet weak var titulosPelicula: UILabel!
    @IBOutlet weak var detallesPelicula: UILabel!
    
    weak var delegate: TableViewCell2Delegate?
    private var currentTask: URLSessionDataTask?
    override func awakeFromNib() {
        super.awakeFromNib()
        imagenPelicula.image = UIImage(named: "placeholder")
        currentTask?.cancel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadImage(from urlString: String?, index: IndexPath) {
        guard let urlString = urlString, !urlString.isEmpty else {
            imagenPelicula.image = UIImage(named: "placeholder")
            return
        }
        delegate?.didStartLoadingImage(in: index)
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(urlString)") else {
            imagenPelicula.image = UIImage(named: "placeholder")
            return
        }
        currentTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.imagenPelicula.image = UIImage(named: "placeholder")
                }
                return
            }
            DispatchQueue.main.async {
                self.imagenPelicula.image = image
            }
        }
        currentTask?.resume()
    }
}
