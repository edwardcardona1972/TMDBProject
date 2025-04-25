//
//  TableViewCellActores.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 24/4/25.
//

import UIKit

class TableViewCellActores: UITableViewCell {
    @IBOutlet weak var viewActor: UIImageView!
    @IBOutlet weak var actor: UILabel!
    @IBOutlet weak var bibliografíaActor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
