//
//  DataSource.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 20/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit


class NasaDataSource : NSObject {
    
    
    var method: ConfigurationsAPi.Method { return .get }
    var timeoutInterval = 30.0
    
    func startLoad( completion:  @escaping ([Items]?, Error?) -> Void) {
        guard let request = try? prepareURLRequest() else {
            completion(nil, ConfigurationsAPi.RequestError.invalidURL)
            return
        }
        
        //request.httpMethod = method.rawValue
        //print(request.url)
        //let url = "https://images-api.nasa.gov/search?q=apollo 11"
        // if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let urlFormat = URL(string: encodedURL){
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, ConfigurationsAPi.RequestError.http(status: (response as! HTTPURLResponse).statusCode))
                    return
            }
            
            DispatchQueue.main.async {
                if let receivedData = data, let items = self.decodeReceivedData(data: receivedData){
                    completion(items, nil)
                }
            }
            
        })
        task.resume()
        // }
        
        
    }
    
    
    private func decodeReceivedData(data : Data) -> [Items]? {
        let decoder = JSONDecoder()
        let items = try? decoder.decode(Nasa.self, from: data).collection.items
        return items
    }
    
    func prepareURLComponents() -> URLComponents? {
        guard let apiURL = URL(string: ConfigurationsAPi.urlBase) else {
            return nil
        }
        
        var urlComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = ConfigurationsAPi.endpoint
        return urlComponents
    }
    
    func prepareURLRequest() throws -> URLRequest {
        let parameters = ConfigurationsAPi.parameters
        
        guard let url = prepareURLComponents()?.url else {
            throw ConfigurationsAPi.RequestError.invalidURL
        }
        
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.query = queryParameters(parameters)
        return URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        
    }
    
    private func queryParameters(_ parameters: [String: Any]?, urlEncoded: Bool = false) -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: ".-_")
        
        var query = ""
        parameters?.forEach { key, value in
            let encodedValue: String
            if let value = value as? String {
                encodedValue = urlEncoded ? value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "" : value
            } else {
                encodedValue = "\(value)"
            }
            query = "\(query)\(key)=\(encodedValue)&"
        }
        return query
    }
    
}

