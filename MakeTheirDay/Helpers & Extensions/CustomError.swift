//
//  CustomError.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/23/21.
//

import Foundation

enum CustomError: LocalizedError {
    
    case ckError(Error)
    case badURL
    case noData
    case thrownError(Error)
    case unableToDecode
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .badURL:
            return "Could not fetch URL."
        case .noData:
            return "No data to fetch."
        case .thrownError:
            return "Problem throwing information."
        case .unableToDecode:
            return "Unable to decode Data"
        }
    }
}
