//
//  ViewController.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 09/05/21.
//

import UIKit
import Swinject
import SnapKit
import RxSwift
import RxCocoa

final class HomeController: UIViewController, StreamControllerProtocol {
    
    //MARK: - Dependencies
    
    private var presenter: HomePresenterProtocol
    
    // MARK: - Properties
    
    private var gridMoviesView = HomeView()
    
    private var loadRow = 0
    private var lastLoadCell = 0
    private var disposeBag = DisposeBag()
    private var searchController = UISearchController(searchResultsController: nil)
    private var alert = UIAlertController(title: "Loading", message: "Wait for some seconds...", preferredStyle: .alert)
    private var loadingCount = 0
    private var isSearching = false
    
    private var movies = BehaviorSubject<[Movie]>(value: [])
    private var filteredMovies = BehaviorSubject<[Movie]>(value: [])
    
    //MARK: - Constructors
    
    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        // self.presenter.cacheGenres()
        
        self.view = gridMoviesView
        
        
        // Setup Streams
         self.setupStreams()
        
        initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setViewToInitialState()
    }
    
    // MARK: - Initialize
    
    /// Realiza um carregamento inicial
    fileprivate func initialLoad() {
        if loadingCount < 1 && !alert.isBeingPresented {
            self.present(alert, animated: true)
        }
        
        // Realiza o carregamento de 10 páginas
        for _ in 0..<10 {
            presenter.loadNewPageMoviesFromNetwork()
            
            loadingCount += 1
        }
    }
    
    // MARK: - Helpers
        
    /// Coloca a view em seu estado inicial
    fileprivate func setViewToInitialState() {
        self.gridMoviesView.collectionView.setContentOffset(.zero, animated: false)
    }
    
}

// MARK: - Configurações das Streams da CollectionView

extension HomeController {
    func setupViewStreams() {
        gridMoviesView.collectionView.rx.didScroll.bind { [weak self] _ in
            self?.loadWhenScroll()
        }.disposed(by: disposeBag)
        
        gridMoviesView.collectionView.rx.itemSelected.bind { [weak self] (index) in
//            if let cell = self?.gridMoviesView.collectionView.cellForItem(at: index) as? MoviesGridCell {
//                self?.presenter.movieCellWasTapped(id: cell.id)
//            }
        }.disposed(by: disposeBag)
        
//        setupSearchBarStreams()
    }
    
    func loadWhenScroll() {
        self.loadRow += 1
        guard let currentCell = self.gridMoviesView.collectionView.visibleCells.last else {
            return
        }
        guard let index = self.gridMoviesView.collectionView.indexPath(for: currentCell)?.row else {
            return
        }
        
        if self.loadRow % 100 == 0 && index > self.lastLoadCell{
            self.presenter.loadNewPageMoviesFromNetwork()
            
            self.lastLoadCell = index
            self.loadRow = 0
        }
    }
}

// MARK: - Configurações das Streams do armazenamento local

extension HomeController {
    func setupLocalStreams() {
        filteredMovies.bind(to: gridMoviesView.collectionView.rx.items(cellIdentifier: "MoviesGridCell")) {
            [weak self] row, data, cell in
            self?.setupCell(data: data, cell: cell as! HomeViewCellCollectionViewCell)
        }.disposed(by: disposeBag)
        
        movies.observe(on: MainScheduler.instance).bind { [weak self] (movies) in
            self?.setFeedbackViewState(movies: movies)
            self?.filteredMovies.onNext(movies)
        }.disposed(by: disposeBag)
    }
    
    func setupCell(data: Movie, cell: HomeViewCellCollectionViewCell) {
        let movieCell = cell
        
        movieCell.label.text = data.overview
        movieCell.image.image = data.image
        movieCell.id = data.id
        movieCell.releaseDate.text = data.releaseDate
//        movieCell.favorite.image = !data.liked ? UIImage(named: "favorite_gray_icon")! : UIImage(named: "favorite_full_icon")!
    }
    
    func setFeedbackViewState(movies: [Movie], error: Bool = false) {
        if error {
            print("Deu error")
//            self.gridMoviesView.feedbackView.show(type: .errorOccurred)

            return
        }

        if movies.isEmpty && !self.isSearching {
            print("Not found")
//            self.gridMoviesView.feedbackView.show(type: .noMoviesAdded)
        } else if movies.isEmpty {
            print("is Empty")
//            self.gridMoviesView.feedbackView.show(type: .noMoviesFounded)
        } else {
            print("Found")
//            self.gridMoviesView.feedbackView.isHidden = true
        }
    }
}

//MARK: - Configurações das Streams do presenter  -
extension HomeController {
    func setupPresenterStreams() {
        presenter.loadMoviesStream.observe(on: MainScheduler.instance).subscribe(onNext: {
            [weak self] movies in
            self?.didEndPageLoad(movies: movies)
        }, onError: { [weak self] _ in
            self?.setFeedbackViewState(movies: [], error: true)
        }).disposed(by: disposeBag)
        
        presenter.reloadMoviesStream.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] (movies) in
            self?.movies.onNext(movies)
        }, onError: { [weak self]  _ in
            self?.setFeedbackViewState(movies: [], error: true)
        }).disposed(by: disposeBag)
    }
    
    func didEndPageLoad(movies: [Movie]) {
        self.loadingCount -= 1
        
        if self.loadingCount < 2 {
            self.alert.dismiss(animated: true)
            self.movies.onNext(movies)
        }
    }
}
