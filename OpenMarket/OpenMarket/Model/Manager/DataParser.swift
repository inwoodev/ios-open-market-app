//
//  DataParser.swift
//  OpenMarket
//
//  Created by James on 2021/09/17.
//

import Foundation

struct DataParser: DataParsible {
    func decodeData<T: Decodable>(_ data: Data, completion: @escaping (_ result: Result<T, DataError>) -> Void) {
        
        guard let item = try? JSONDecoder().decode(T.self, from: data) else {
            return completion(.failure(DataError.decoding))
        }
        
        completion(.success(item))
    }
    
    func encodeToJSON<T: Encodable> (data: T) -> Result<Data, DataError> {
        
        guard let json = try? JSONEncoder().encode(data) else {
            return .failure(DataError.encoding)
        }
        return .success(json)
    }
    
}
