//
//  Publisher.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//

import Combine

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map(Result.success)
            .catch { error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
