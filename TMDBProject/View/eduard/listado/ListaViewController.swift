//
//  ListaViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//
import UIKit
import Combine

class ListaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var Tv: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    private var selectedIndexPathForSegue: IndexPath?
    private var cellSubscriptions: [IndexPath: AnyCancellable] = [:]
    var peliculasProvider: peliculasProviderProtocol = PeliculasProviderNetwork()
    var viewModel: ListaViewModel!
    var anyCancellables: Set<AnyCancellable> = []
    var pagina: Int = 1
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ListaViewModel(peliculasProviderProtocol: peliculasProvider)
        subscriptions()
        viewModel.getPeliculas(pagina: String(pagina))
        Tv.register(UINib(nibName: "TableViewCell2", bundle: nil), forCellReuseIdentifier: "celda")
        Tv.delegate = self
        Tv.dataSource = self
        mySearchBar.delegate = self
    }
    
    func subscriptions() {
        viewModel.$filteredPeliculas
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
            if let vc = segue.destination as? DetalleViewController,
               let indexPath = selectedIndexPathForSegue,
               indexPath.row < viewModel.filteredPeliculas.count {
                vc.idPelicula = viewModel.filteredPeliculas[indexPath.row].id
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredPeliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as? TableViewCell2 else {
            fatalError("No se pudo crear la celda")
        }
        let pelicula = viewModel.filteredPeliculas[indexPath.row]
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
        if !isSearching && indexPath.row == viewModel.filteredPeliculas.count - 1 {
            pagina += 1
            viewModel.getPeliculas(pagina: String(pagina))
        }
    }
}

extension ListaViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        viewModel.searchValue = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        viewModel.searchValue = ""
        searchBar.resignFirstResponder()
        viewModel.getPeliculas(pagina: String(1))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text, !searchText.isEmpty {
            isSearching = true
            viewModel.buscarPeliculas(query: searchText)
        } else {
            viewModel.getPeliculas(pagina: String(1))
            isSearching = false
        }
    }
}
