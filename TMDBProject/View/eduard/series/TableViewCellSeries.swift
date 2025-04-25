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
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
