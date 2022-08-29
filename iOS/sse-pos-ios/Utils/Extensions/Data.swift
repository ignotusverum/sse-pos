//
//  Parsing.swift
//  sse-pos-ios
//
//  Created by Vlad Z. on 8/28/22.
//

import Foundation

extension JSONDecoder {
    static let defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension Data {
    func map<T>(to: T.Type) throws -> T where T: Decodable {
        try JSONDecoder.defaultDecoder.decode(T.self,
                                              from: self)
    }
}
