//
//  ListaViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//
import UIKit
import Combine

class ListaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Tv: UITableView!
    private var selectedIndexPathForSegue: IndexPath?
    private var cellSubscriptions: [IndexPath: AnyCancellable] = [:]
    var viewModel: ListaViewModel = ListaViewModel(peliculasProviderProtocol: PeliculasProviderNetwork())
    var anyCancellables: Set<AnyCancellable> = []
    var pagina: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        viewModel.getPeliculas(pagina: String(pagina))
        Tv.register(UINib(nibName: "TableViewCell2", bundle: nil), forCellReuseIdentifier: "celda")
        Tv.delegate = self
        Tv.dataSource = self
    }
    
    func subscriptions() {
        viewModel.$peliculas
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.Tv.reloadData()
            }
            .store(in: &anyCancellables)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPathForSegue = indexPath
        performSegue(withIdentifier: "detalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalle" {
            let vc = segue.destination as? DetalleViewController
            vc!.idPelicula = viewModel.peliculas[selectedIndexPathForSegue!.row].id
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as? TableViewCell2 else {
            fatalError("No se pudo crear la celda")
        }
        let pelicula = viewModel.peliculas[indexPath.row]
        cell.titulosPelicula.text = pelicula.title
        cell.detallesPelicula.text = pelicula.overview
        cell.imagenPelicula.image = UIImage(named: "placeholder")
        cellSubscriptions[indexPath]?.cancel()
        cellSubscriptions[indexPath] = nil
        cell.configure(with: pelicula, viewModel: viewModel, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellSubscriptions[indexPath]?.cancel()
        cellSubscriptions.removeValue(forKey: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.peliculas.count - 1 {
            pagina += 1
            viewModel.getPeliculas(pagina: String(pagina))
        }
    }
}
