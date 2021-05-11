//
//  ConvertMovieEntityToModelUseCase.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 11/05/21.
//

import UIKit
import RxSwift

/// Converte uma MovieEntity em uma instância do tipo Movie
final class ConvertMovieEntityToModelUseCase: UseCase<Array<MovieEntity>, Array<Movie>> {
    
    private var genreMemoryRepository: GenreMemoryRepositoryProtocol
    
    init(genreMemoryRepository: GenreMemoryRepositoryProtocol) {
        self.genreMemoryRepository = genreMemoryRepository
    }
    
    override func run(_ params: [MovieEntity]...) {
        
        guard let movies = params.first else {
            fatalError("This use case needs the parameter movies entity")
        }
        
        var moviesAux = [Movie]()
        for movieEntity in movies {
            let movie = convert(entity: movieEntity)
            moviesAux.append(movie)
        }
        
        resultPublisher.onNext(moviesAux)
    }
    
    private func convert(entity: MovieEntity) -> Movie {
        var image: UIImage = UIImage()
        
        let url = URL(string: NetworkConstants.baseImageURL + entity.posterPath)!
        if let data = try? Data(contentsOf: url) {
            image = UIImage(data: data)!
        } else {
            image = UIImage()
        }
        
        var genres = [Genre]()
        
        for genreId in entity.genreIds {
            if let genre = genreMemoryRepository.getGenre(with: genreId) {
                genres.append(genre)
            }
        }
        
        let movie = Movie(id: entity.id,
                          title: entity.title,
                          image: image,
                          releaseDate: entity.releaseDate,
                          overview: entity.overview,
                          genres: genres)
        
        return movie
    }
}
