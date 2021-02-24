//
//  CustomError.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/23/21.
//

import Foundation

enum CustomError: LocalizedError {
    
    case badURL
    case noData
    case thrownError(Error)
    case unableToDecode
}
