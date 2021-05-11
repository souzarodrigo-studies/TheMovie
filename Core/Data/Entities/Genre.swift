//
//  Genre.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 10/05/21.
//

import Foundation
import UIKit

/// Estrutura utilizada para mapear resposta da requisição de generos
struct GenresResponse: Codable {
    public let genres: [Genre]
}

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}
