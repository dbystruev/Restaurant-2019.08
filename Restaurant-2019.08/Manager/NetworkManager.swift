//
//  NetworkManager.swift
//  Restaurant-2019.08
//
//  Created by Denis Bystruev on 22/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class NetworkManager {
    let baseURL = URL(string: "http://server.getoutfit.ru:8090")!
    
    func getCategories(completion: @escaping ([String]?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(Categories.self, from: data)
                completion(decodedData.categories, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func getMenuItems(for category: String, completion: @escaping ([MenuItem]?, Error?) -> Void) {
        let initialUrl = baseURL.appendingPathComponent("menu")
        guard let url = initialUrl.withQueries(["category": category]) else {
            completion(nil, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(MenuItems.self, from: data)
                completion(decodedData.items, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func getImage(_ initialURL: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        var components = URLComponents(url: initialURL, resolvingAgainstBaseURL: true)
        components?.host = baseURL.host
        guard let url = components?.url else {
            completion(nil, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
        }
        task.resume()
    }
}
