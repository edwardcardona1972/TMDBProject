//
//  TableViewCell2.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 9/4/25.
//

import UIKit
protocol TableViewCell2Delegate: AnyObject {
    func didStartLoadingImage(in cell: TableViewCell2)
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
    
    func loadImage(from urlString: String?){
        guard let urlString = urlString, !urlString.isEmpty else{
            imagenPelicula.image = UIImage(named: "placeholder")
            return
        }
        print("load imagen table view cell 2")
        delegate?.didStartLoadingImage(in: self)
    }
}
