//
//  DataParsible.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import Foundation

protocol DataParsible {
    func decodeData<T: Decodable>(_ data: Data, completion: @escaping (_ result: Result<T, DataError>) -> Void)
    func encodeToJSON<T: Encodable> (data: T) -> Result<Data, DataError>
}
