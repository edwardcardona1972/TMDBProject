//
//  DetalleViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 27/3/25.
//

import UIKit

class DetalleViewController: UIViewController {
    
    @IBOutlet weak var viewPersonaje: UIImageView!
    @IBOutlet weak var descripcion: UITextView!
    var pelicula: Pelicula?
    var selectedTypeIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tv.delegate = self
        //tv.dataSource = self
        
    }
}

