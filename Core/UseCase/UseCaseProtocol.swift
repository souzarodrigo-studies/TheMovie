//
//  UseCaseProtocol.swift
//  TheMovie
//
//  Created by Rodrigo Santos on 10/05/21.
//

import Foundation
import RxSwift

protocol UseCaseProtocol {
    associatedtype ResultType
    associatedtype ParamType
    
    var resultStream: Observable<ResultType> { get }
    
    func run(_ params: ParamType...)
}

class UseCase<P, R>: UseCaseProtocol {
    typealias ResultType = R
    typealias ParamType = P
    
    var resultPublisher = PublishSubject<R>()
    var resultStream: Observable<R> {
        get {
            return resultPublisher.asObservable()
        }
    }
    
    func run(_ params: P...) {}
}
