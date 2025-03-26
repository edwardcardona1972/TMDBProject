//
//  ListaViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//

import UIKit

class ListaViewController: UIViewController {
    
    @IBOutlet weak var tv: UITableView!
    var presenter: ListaPresenter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let providerProtocol: PeliculasProviderProtocol = PeliculasProviderMock()
        presenter = ListaPresenter(peliculasProviderProtocol: providerProtocol)
        
        tv.delegate = self
        tv.dataSource = self
        //añadir los delegados de la tabla ejemplo tv.delegate = self
        Task{
            await presenter?.getPeliculas()
            tv.reloadData()
        }
    }
}
extension ListaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.peliculas.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pelicula = presenter?.peliculas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pelicula?.title
        return cell
    }
}
