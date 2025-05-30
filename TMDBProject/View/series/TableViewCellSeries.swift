//
//  TableViewCellSeries.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/4/25.
//

import UIKit
import Combine

class TableViewCellSeries: UITableViewCell {
    @IBOutlet weak var imageViewSeries: UIImageView!
    @IBOutlet weak var tituloSeries: UILabel!
    @IBOutlet weak var estrenoSeries: UILabel!

    private var cancellable: AnyCancellable?

    override func awakeFromNib() {
        layer.borderColor = UIColor.lightGray.cgColor
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
        cancellable = nil
    }

    func configure(serie: Serie) {
        tituloSeries.text = serie.original_name
        estrenoSeries.text = serie.overview
        if let path = serie.poster_path {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w200\(path)")!
            cancellable = URLSession.shared.dataTaskPublisher(for: imageUrl)
                .receive(on: DispatchQueue.main)
                .map { UIImage(data: $0.data) }
                .sink(receiveCompletion: { completion in
                }, receiveValue: { [weak self] image in
                    self?.imageViewSeries.image = image
                })
        }
    }
}
