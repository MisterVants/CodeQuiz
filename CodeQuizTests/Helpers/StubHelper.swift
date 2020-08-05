//
//  StubHelper.swift
//  CodeQuizTests
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

class StubHelper {
    
    func stub<T: Decodable>(fromJSON name: String) throws -> T {
        do {
            let decodable = try data(fromResource: name, ofType: "json")
            let decoded = try JSONDecoder().decode(T.self, from: decodable)
            return decoded
        } catch {
            throw error
        }
    }
    
    func data(fromResource name: String, ofType ext: String) throws -> Data {
        guard let path = Bundle(for: type(of: self)).path(forResource: name, ofType: ext) else { throw NSError() }
        do {
            let url = URL(fileURLWithPath: path)
            let fileData = try Data(contentsOf: url, options: .uncached)
            return fileData
        } catch {
            throw error
        }
    }
}
