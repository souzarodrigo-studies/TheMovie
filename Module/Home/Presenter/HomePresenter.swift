//
//  HomePresenter.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 10/05/21.
//

import Foundation
import RxSwift

protocol HomePresenterProtocol {
    var loadMoviesStream: Observable<[Movie]> { get }
    var reloadMoviesStream: Observable<[Movie]> { get }
    
    func loadNewPageMoviesFromNetwork()
    func loadMoviesFromCache()
    func movieCellWasTapped(id: Int)
    func cache()
}

final class HomePresenter: HomePresenterProtocol {
    
    private let loadMoviesUseCase: UseCase<Void, Array<Movie>>
    
    private let disposeBag = DisposeBag()
    
    /// Fluxo de retorno: É chamado quando os filmes acabam de ser carregados da API (Já estão em cache na memória)
    private let loadMoviesPublisher = BehaviorSubject<[Movie]>(value: [])
    var loadMoviesStream: Observable<[Movie]> {
        get {
            return loadMoviesPublisher.asObservable()
        }
    }
    
    /// Fluxo de retorno: É chamado quando os filmes acabam de ser carregados da memória
    private let reloadMoviesPublisher = BehaviorSubject<[Movie]>(value: [])
    var reloadMoviesStream: Observable<[Movie]> {
        get {
            return reloadMoviesPublisher.asObservable()
        }
    }
    
    init(loadMoviesUseCase: UseCase<Void, Array<Movie>>) {
        self.loadMoviesUseCase = loadMoviesUseCase
        
        self.loadMoviesUseCase.resultStream.bind(to: loadMoviesPublisher).disposed(by: disposeBag)
    }
    
    
    /// Carrega filmes diretamente da API
    func loadNewPageMoviesFromNetwork() {
        loadMoviesUseCase.run()
    }
    
    /// Carrega filmes do cache na memória
    func loadMoviesFromCache() {
//        loadMoviesFromCacheUseCase.run()
    }
    
    /// Mostra a tela de detalhes
    ///
    /// - Parameter id: Índice da célula que foi clicada
    func movieCellWasTapped(id: Int) {
//        showMovieDetailsUseCase.run(id)
    }
    
    /// Realiza o cache dos dados
    func cache() {
        
    }

}
