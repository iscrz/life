//
//  State.swift
//  Cooridnator
//
//  Created by Work on 5/3/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import Combine

public protocol State {}

extension Publisher where Output: State, Failure == Never {
    
    /// Checks duplicates on the value of the keypath and returns a new publisher
    public func new<T: Equatable>(_ keyPath: KeyPath<Self.Output, T>) -> AnyPublisher<T, Never> {
        self.map(keyPath)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// Checks for duplicates on the value of an array at keypath and returns a stream of publishers.
    public func enumerate<T, E>(_ keyPath: KeyPath<Self.Output, T>)
        -> AnyPublisher<(offset: Int, element: E), Never>
        where T: Collection, T: Equatable, E == T.Element
        {
        
        self.map(keyPath)
            .removeDuplicates()
            .flatMap { $0.enumerated().publisher }
            .eraseToAnyPublisher()
    }
}
