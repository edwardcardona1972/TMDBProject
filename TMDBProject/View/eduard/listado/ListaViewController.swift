//
//  ListaViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//

import UIKit

class ListaViewController: UIViewController {

    var listaViewModel: ListaViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaViewModel = ListaViewModel()
    }
    
}
