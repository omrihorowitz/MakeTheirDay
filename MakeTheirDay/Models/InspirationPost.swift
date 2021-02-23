//
//  InspirationPost.swift
//  MakeTheirDay
//
//  Created by Omri Horowitz on 2/17/21.
//
import UIKit

struct Image {
    let image: UIImage
}

struct Quote: Decodable {
    let text: String
    let author: String?
}

