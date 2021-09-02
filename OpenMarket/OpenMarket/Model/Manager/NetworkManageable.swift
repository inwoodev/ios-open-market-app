//
//  NetworkManageable.swift
//  OpenMarket
//
//  Created by James on 2021/06/01.
//

import UIKit

protocol NetworkManageable {
    var dataTask: URLSessionDataTask? { get set}
    var urlSession: URLSessionProtocol { get }
    var isReadyToPaginate: Bool { get set }
    var boundary: String { get }
    
    func getItemList(page: Int, loadingFinished: Bool, completionHandler: @escaping (_ result: Result <OpenMarketItemList, Error>) -> Void)
    
    func getSingleItem(itemURL: String, id: Int, completion: @escaping (_ result: Result <OpenMarketItemToGet, NetworkResponseError>) -> Void)
    
    func postSingleItem(url: String, texts: [String : Any?], imageList: [UIImage], completionHandler: @escaping (URLSessionDataTask) -> Void)
    
}
extension NetworkManageable {
    func examineNetworkResponse(page: Int, completionHandler: @escaping (_ result: Result <HTTPURLResponse, Error>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(page)") else {
            return completionHandler(.failure(NetworkResponseError.badRequest))
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(NetworkResponseError.noData))
                print(dataError.localizedDescription)
            }
            if let urlResponse = response as? HTTPURLResponse {
                let urlResponseResult = self.handleNetworkResponseError(urlResponse)
                switch urlResponseResult {
                case .failure(let errorDescription):
                    print(errorDescription)
                    return completionHandler(.failure(NetworkResponseError.badRequest))
                case .success:
                    completionHandler(.success(urlResponse))
                }
            }
        }.resume()
    }
    
    func examineNetworkRequest(page: Int, completionHandler: @escaping (_ result: Result <URLRequest, Error>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(page)") else {
            return completionHandler(.failure(NetworkResponseError.badRequest))
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(NetworkResponseError.noData))
                print(dataError.localizedDescription)
            }
            if let urlResponse = response as? HTTPURLResponse {
                let urlResponseResult = self.handleNetworkResponseError(urlResponse)
                switch urlResponseResult {
                case .failure(let errorDescription):
                    print(errorDescription)
                    return completionHandler(.failure(NetworkResponseError.badRequest))
                case .success:
                    completionHandler(.success(urlRequest))
                }
            }
        }.resume()
    }
    
    func handleNetworkResponseError(_ response: HTTPURLResponse) -> NetworkResponseResult<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponseError.authenticationError.description)
        case 501...599:
            return .failure(NetworkResponseError.badRequest.description)
        case 600:
            return .failure(NetworkResponseError.outdated.description)
        default:
            return .failure(NetworkResponseError.failed.description)
        }
    }
}

// MARK: - Cell image download Task

extension NetworkManageable {
    
    func imageDownloadDataTask(url: URL, completionHandler: @escaping (UIImage) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { data, response, error in
            guard let completeData = data,
                  let imageData = UIImage(data: completeData) else { return }
            completionHandler(imageData)
        }
    }
}

// MARK: - Multipart/form-data

extension NetworkManageable {
    private func convertTextField(key: String, value: String, boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    private func convertFileData(key: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
    
    func buildMultipartFormData(_ texts: [String: Any?], _ imageList: [UIImage]) -> Data {
        let httpBody = NSMutableData()
        
        for (key, value) in texts {
            if let validValue = value {
                let convertedValue = String(describing: validValue)
                httpBody.appendString(convertTextField(key: key, value: convertedValue, boundary: boundary))
            }
            
        }
        
        for image in imageList {
            
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                return Data()
                
            }
            
            let convertedImage = imageData.base64EncodedData()
            let stringData = String(bytes: convertedImage, encoding: .utf8)
            print("이미지데이터: \(imageData)")
            let finalData = Data(base64Encoded: stringData!)
            httpBody.append(convertFileData(key: OpenMarketItemToPost.images.key, fileName: "\(Date().timeIntervalSince1970)_photo.jpeg", mimeType: "image/jpeg", fileData: finalData!, using: boundary))
        }
        httpBody.appendString("--\(boundary)--")
        return httpBody as Data
    }
}
