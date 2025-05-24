//
//  TableViewCellActores.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/4/25.
//

import UIKit
import Combine

class ActoresTableViewCell: UITableViewCell {
    @IBOutlet weak var imageActor: UIImageView!
    @IBOutlet weak var nombreActorLabel: UILabel!
    @IBOutlet weak var bibliografiaActor: UILabel!
    
    private var cancellable: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //layer.borderColor = UIColor.lightGray.cgColor
        //layer.borderWidth = 1.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
        cancellable = nil
    }
    
    func configure(actor: Actor) {
        nombreActorLabel.text = actor.name
        bibliografiaActor.text = actor.popularity?.description
        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w200\(actor.profile_path)")!
        cancellable = URLSession.shared.dataTaskPublisher(for: imageUrl)
            .receive(on: DispatchQueue.main)
            .map { UIImage(data: $0.data) }
            .sink(receiveCompletion: { completion in
            }, receiveValue: { [weak self] image in
                self?.imageActor.image = image
            })
    }
}
