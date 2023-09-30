//
//  DataParser.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

class DataParser: DataParserProtocol {
    
    // MARK: Properties
    private var jsonDecoder: JSONDecoder
    
    // MARK: Init
    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: Helpers
    func parse<T: Decodable>(data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
