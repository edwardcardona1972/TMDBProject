//
//  ListaViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 25/3/25.
//
import UIKit
import Combine

protocol ListaViewModelDelegate: AnyObject {
    func didLoadImage(image: UIImage, at indexPath: IndexPath)
}

class ListaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ListaViewModelDelegate {
   
    @IBOutlet weak var Tv: UITableView!
    private var selectedIndexPathForSegue: IndexPath?
    private var loadedImages: [IndexPath: UIImage] = [:]
    weak var delegate: ListaViewModelDelegate?
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
        viewModel.reloadData.sink { _ in} receiveValue: { _ in
            self.Tv.reloadData()
        }.store(in: &anyCancellables)
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
        print(cell)
        cell.titulosPelicula.text = pelicula.title
        cell.detallesPelicula.text = pelicula.overview
        cell.imagenPelicula.image = loadedImages[indexPath] ?? UIImage(named: "placeholder")
        
        if let loadedImage = loadedImages[indexPath] {
            cell.imagenPelicula.image = loadedImage
        } else {
            cell.imagenPelicula.image = UIImage(named: "placeholder")
            cell.loadImage(from: pelicula.poster_path, index: indexPath)
        }
        return cell
    }
    
    //MARK: - ListaViewModelDelegate
    func didLoadImage(image: UIImage, at indexPath: IndexPath) {
        loadedImages[indexPath] = image
        Tv.reloadRows(at: [indexPath], with: .none)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.peliculas.count - 1 {
            pagina += 1
            viewModel.getPeliculas(pagina: String(pagina))
        }
    }
}
