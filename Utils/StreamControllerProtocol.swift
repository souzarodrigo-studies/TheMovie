//
//  StreamControllerProtocol.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 11/05/21.
//

import Foundation

protocol StreamControllerProtocol {
    func setupPresenterStreams()
    func setupViewStreams()
    func setupLocalStreams()
}

extension StreamControllerProtocol {
    func setupStreams() {
        self.setupLocalStreams()
        self.setupViewStreams()
        self.setupPresenterStreams()
    }
}
