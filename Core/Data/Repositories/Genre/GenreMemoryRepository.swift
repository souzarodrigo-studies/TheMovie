//
//  GenreMemoryRepository.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 10/05/21.
//

import Foundation

protocol GenreMemoryRepositoryProtocol {
    func cache(genres: [Genre])
    func getGenre(with id: Int) -> Genre?
    func getAll() -> [Genre]
}


final class GenreMemoryRepository: GenreMemoryRepositoryProtocol {
    private var genres = [Genre]()
    
    func cache(genres: [Genre]) {
        self.genres.append(contentsOf: genres)
    }
    
    func getGenre(with id: Int) -> Genre?{
        return genres.filter({
            genre in
            return genre.id == id
        }).first
    }
    
    func getAll() -> [Genre] {
        return genres
    }
}
