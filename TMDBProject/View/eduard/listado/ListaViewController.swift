//
//  ListaViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//

import UIKit

class ListaViewController: UIViewController {
    
    var presenter: ListaPresenter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let providerProtocol: PeliculasProviderProtocol = PeliculasProviderMock()
        presenter = ListaPresenter(peliculasProviderProtocol: providerProtocol)
        Task{
            await presenter?.getPeliculas()
            for peli in presenter?.peliculas ?? [] {
                print(peli.title)    }
        }
    }
}
