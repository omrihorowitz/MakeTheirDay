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
    static let quoteURL = URL(string: "https://type.fit/api/quotes")
    
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
            fetchImageWith(url: "https://source.unsplash.com/1600x900/?gratitude,life") { (result) in
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
            fetchImageWith(url: "https://source.unsplash.com/1600x900/?mindfulness,sky") { (result) in
                switch result {
                case .success(let image):
                    placeholderArray.append(image)
                    group.leave()
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?fire,motivation") { (result) in
        switch result {
        case .success(let image):
            placeholderArray.append(image)
            group.leave()
        case .failure(let error):
            return completion(.failure(error))
        }
    }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?artist,strength") { (result) in
            switch result {
            case .success(let image):
                placeholderArray.append(image)
                group.leave()
            case .failure(let error):
                return completion(.failure(error))
            }
        }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?park,clarity") { (result) in
            switch result {
            case .success(let image):
                placeholderArray.append(image)
                group.leave()
            case .failure(let error):
                return completion(.failure(error))
            }
        }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?work,perseverance") { (result) in
            switch result {
            case .success(let image):
                placeholderArray.append(image)
                group.leave()
            case .failure(let error):
                return completion(.failure(error))
            }
        }
        group.enter()
        fetchImageWith(url: "https://source.unsplash.com/1600x900/?flower,peace") { (result) in
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
    
    static func fetchQuote(completion: @escaping (Result<[Quote],CustomError>) -> Void) {
        guard let quoteURL = quoteURL else {return completion(.failure(.badURL))}
        URLSession.shared.dataTask(with: quoteURL) { (data, _, error) in
            
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let quoteList = try JSONDecoder().decode([Quote].self, from: data)
                var placeholderArray: [Quote] = []
                var count = 0
                while count < 10 {
                    guard let quote = quoteList.randomElement() else {return completion(.failure(.noData))}
                    placeholderArray.append(quote)
                    count += 1
                }
                completion(.success(placeholderArray))
            } catch {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
