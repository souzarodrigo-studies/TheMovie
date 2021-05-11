//
//  HomeBuider.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 10/05/21.
//

import UIKit
import Swinject

final class HomeBuilder {
    
    // Controller raiz do modulo de apresentação
    private(set) var controller: UIViewController
    
    private init(controller: UIViewController) {
        self.controller = controller
    }
    
    /**
     * Factory responsável pela instanciação e configuração do módulo
     */
    static func build(with container: Container) -> HomeBuilder{
        
        guard let movieMemoryRepository = container.resolve(MovieMemoryRepositoryProtocol.self) else {
            fatalError("It's necessary initialize the MovieMemoryRepositoryProtocol on AppDelegate+DISetup")
        }
        
        guard let movieNetworkRepository = container.resolve(MovieNetworkRepositoryProtocol.self) else {
            fatalError("It's necessary initialize the MovieMemoryRepositoryProtocol on AppDelegate+DISetup")
        }
        
        guard let genreMemoryRepository = container.resolve(GenreMemoryRepositoryProtocol.self) else {
            fatalError("It's necessary initialize the GenreMemoryRepositoryProtocol on AppDelegate+DISetup")
        }
        
//        guard let genreNetworkRepository = container.resolve(GenreNetworkRepositoryProtocol.self) else {
//            fatalError("It's necessary initialize the GenreNetworkRepositoryProtocol on AppDelegate+DISetup")
//        }
        
        let convertMovieEntityToModelUseCase = ConvertMovieEntityToModelUseCase(genreMemoryRepository: genreMemoryRepository)
        
        let loadMoviesUseCase = LoadMoviesFromNetworkAndCacheUseCase(memoryRepository: movieMemoryRepository,
                                                  networkRepository: movieNetworkRepository, convertMovieEntityToModelUseCase: convertMovieEntityToModelUseCase)
        
        let presenter = HomePresenter(loadMoviesUseCase: loadMoviesUseCase)
        
        let controller = HomeController(presenter: presenter)
        
        return .init(controller: controller)
    }
}
