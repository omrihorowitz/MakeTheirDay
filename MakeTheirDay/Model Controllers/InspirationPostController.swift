//
//  InspirationPostController.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//

import UIKit

class InspirationPostController {
    //https://source.unsplash.com/1600x900/?nature,inspiration
    static var imageURL = URL(string: "https://source.unsplash.com/1600x900/")
    
    static func fetchImageWith(url: String, completion: @escaping (Result<UIImage, CustomError>) -> Void) {
        guard let imageURL = URL(string: url) else {return completion(.failure(.badURL))}
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            
            completion(.success(image))
        }.resume()
    }
    
    static func fetchUniqueImages(completion: @escaping (Result<[UIImage], CustomError>) -> Void) {
        var placeholderArray: [UIImage] = []
        let group = DispatchGroup()
            group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?nature,inspiration") { (result) in
            switch result {
            case .success(let image):
                placeholderArray.append(image)
                group.leave()
            case .failure(let error):
                return completion(.failure(error))
            }
        }
            group.enter()
            fetchImageWith(url: "https://source.unsplash.com/1600x900/?meditation,city") { (result) in
                switch result {
                case .success(let image):
                    placeholderArray.append(image)
                    group.leave()
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
            group.enter()
            fetchImageWith(url: "https://source.unsplash.com/1600x900/?gratitude,wallpaper") { (result) in
                switch result {
                case .success(let image):
                    placeholderArray.append(image)
                    group.leave()
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
            group.enter()
            fetchImageWith(url: "https://source.unsplash.com/1600x900/?love,family") { (result) in
                switch result {
                case .success(let image):
                    placeholderArray.append(image)
                    group.leave()
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
            group.enter()
            fetchImageWith(url: "https://source.unsplash.com/1600x900/?reflection,sky") { (result) in
                switch result {
                case .success(let image):
                    placeholderArray.append(image)
                    group.leave()
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?fire,zen") { (result) in
        switch result {
        case .success(let image):
            placeholderArray.append(image)
            group.leave()
        case .failure(let error):
            return completion(.failure(error))
        }
    }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?artist,inspiration") { (result) in
            switch result {
            case .success(let image):
                placeholderArray.append(image)
                group.leave()
            case .failure(let error):
                return completion(.failure(error))
            }
        }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?art,wisdom") { (result) in
            switch result {
            case .success(let image):
                placeholderArray.append(image)
                group.leave()
            case .failure(let error):
                return completion(.failure(error))
            }
        }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?sports,perseverance") { (result) in
            switch result {
            case .success(let image):
                placeholderArray.append(image)
                group.leave()
            case .failure(let error):
                return completion(.failure(error))
            }
        }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?music,peace") { (result) in
            switch result {
            case .success(let image):
                placeholderArray.append(image)
                group.leave()
            case .failure(let error):
                return completion(.failure(error))
            }
        }
            group.notify(queue: .main) {
                completion(.success(placeholderArray))
            }
    }
}
