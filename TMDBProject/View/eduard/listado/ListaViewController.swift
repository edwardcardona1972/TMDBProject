//
//  ListaViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//

import UIKit
import Combine

class ListaViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tv: UITableView!
    
    var viewModel: ListaViewModel? = nil
    var anyCancellables: Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.delegate = self
        tv.dataSource = self
        
        let providerProtocol: PeliculasProviderProtocol = PeliculasProviderMock()
        viewModel = ListaViewModel(peliculasProviderProtocol: providerProtocol)
        viewModel?.getPeliculas()
        subscriptions()
    }
    func subscriptions() {
        viewModel?.reloadData.sink { _ in} receiveValue: { _ in           
        }.store(in: &anyCancellables)
        self.tv.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "detalle", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalle" {
            let vc = segue.destination as! DetalleViewController
            vc.pelicula = viewModel?.peliculas[tv.indexPathForSelectedRow!.row]
        }
    }
}

extension ListaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.peliculas.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pelicula = viewModel?.peliculas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pelicula?.title
        cell.detailTextLabel?.text = pelicula?.overview ?? ""
        
        let url = URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w500/" + (pelicula?.poster_path ?? ""))!)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }.resume()
        return cell
    }
}
