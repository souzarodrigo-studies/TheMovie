//
//  GenreNetworkRepository.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 10/05/21.
//

import Foundation
import RxSwift

protocol GenreNetworkRepositoryProtocol {
    var getGenresStream: Observable<[Genre]> { get }
    
    func getGenres()
}

final class GenreNetworkRepository: GenreNetworkRepositoryProtocol {
    
    private var service: TheMovieServiceAPI
    private var disposeBag = DisposeBag()
    
    private var getGenresPublisher = PublishSubject<[Genre]>()
    var getGenresStream: Observable<[Genre]> {
        get {
            return getGenresPublisher.asObservable()
        }
    }
    
    init(service: TheMovieServiceAPI) {
        self.service = service
    }
    
    func getGenres() {
        self.service.fetchGenres().bind(onNext: { [weak self] result  in
            switch result {
            case .success(let genresResponse):
                self?.getGenresPublisher.onNext(genresResponse.genres)
            case .failure(let error):
                self?.getGenresPublisher.onError(error)
            }
        }).disposed(by: disposeBag)
    }
}
