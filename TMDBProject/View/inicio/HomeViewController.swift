//
//  HomeViewController.swift
//  TMDBProject
//
//  Created by Eduard Alexis Cardona Grajales on 29/4/25.
//
import UIKit
import Combine

class HomeViewController: UIViewController {
    @IBOutlet weak var actoresTableView: UITableView!
    @IBOutlet weak var peliculasTableView: UITableView!
    @IBOutlet weak var seriesTableView: UITableView!
    
    private var homeViewModel: HomeViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private var selectedIndexPathForSegue: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActoresTable()
        setupSeriesTable()
        setupPeliculasTable()
        
        homeViewModel = HomeViewModel(
            actoresProvider: ActoresProviderNetwork(),
            seriesProvider: SeriesProviderNetwork(),
            peliculasProvider: PeliculasProviderNetwork()
        )
        
        setupObservers()
    }
    
    func setupActoresTable() {
        actoresTableView.delegate = self
        actoresTableView.dataSource = self
        actoresTableView.register(UINib(nibName: "TableViewCellActores", bundle: nil), forCellReuseIdentifier: "ActorTableViewCell")
    }
    
    func setupSeriesTable() {
        seriesTableView.delegate = self
        seriesTableView.dataSource = self
        seriesTableView.register(UINib(nibName: "TableViewCellSeries", bundle: nil), forCellReuseIdentifier: "SerieCell")
    }
    
    func setupPeliculasTable() {
        peliculasTableView.delegate = self
        peliculasTableView.dataSource = self
        peliculasTableView.register(UINib(nibName: "TableViewCellPelicula", bundle: nil), forCellReuseIdentifier: "PeliculaCell")
    }
    
    func setupObservers() {
        homeViewModel.$listaDeActores
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in /* ... */ },
                  receiveValue: { [weak self] actores in
                      self?.actoresTableView.reloadData()
                  })
            .store(in: &cancellables)
        
        
        homeViewModel.$listaDeSeries
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in /* ... */ },
                  receiveValue: { [weak self] series in
                      self?.seriesTableView.reloadData()
                  })
            .store(in: &cancellables)
        
        homeViewModel.$listaDePeliculas
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in /* ... */ },
                  receiveValue: { [weak self] peliculas in
                      self?.peliculasTableView.reloadData()
                  })
            .store(in: &cancellables)
    }
    
    @IBAction func goToActoresButton() {
        //performSegue(withIdentifier:"Actores", sender: self)
    }
    
    @IBAction func goToSeriesButton() {
        //performSegue(withIdentifier:"Series", sender: self)
    }
    
    @IBAction func goToPeliculasButton() {
        performSegue(withIdentifier:"Peliculas", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detallePelicula" {
            if let vc = segue.destination as? DetalleViewController,
               let indexPath = selectedIndexPathForSegue,
               indexPath.row < homeViewModel.listaDePeliculas.count {
                vc.idPelicula = homeViewModel.listaDePeliculas[indexPath.row].id
            }
        } else if segue.identifier == "detalleSerie" {
            
        } else if segue.identifier == "detalleActor" {
            
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == actoresTableView {
            return homeViewModel.listaDeActores.count
        } else if tableView == peliculasTableView {
            return homeViewModel.listaDePeliculas.count
        } else if tableView == seriesTableView {
            return homeViewModel.listaDeSeries.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == actoresTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActorTableViewCell", for: indexPath) as! ActoresTableViewCell
            let actor = homeViewModel.listaDeActores[indexPath.row]
            cell.configure(actor: actor)
            return cell
        } else if tableView == peliculasTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeliculaCell", for: indexPath) as! TableViewCellPelicula
            let pelicula = homeViewModel.listaDePeliculas[indexPath.row]
            cell.configure(pelicula: pelicula)
            return cell
        } else if tableView == seriesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SerieCell", for: indexPath) as! TableViewCellSeries
            let serie = homeViewModel.listaDeSeries[indexPath.row]
            cell.configure(serie: serie)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPathForSegue = indexPath
        if tableView == actoresTableView {
            performSegue(withIdentifier: "detalleActor", sender: self)
        } else if tableView == peliculasTableView {
            performSegue(withIdentifier: "detallePelicula", sender: self)
        } else if tableView == seriesTableView {
            performSegue(withIdentifier: "detalleSerie", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == actoresTableView {
            return "Actores"
        } else if tableView == peliculasTableView {
            return "Películas"
        } else if tableView == seriesTableView {
            return "Series"
        }
        return nil
    }
}

