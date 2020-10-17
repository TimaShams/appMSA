//
//  book.swift
//  MSA
//
//  Created by MacBook Pro on 18/10/20.
//  Copyright © 2020 FatemaShams. All rights reserved.
//

import Foundation
import UIKit

struct myList: Decodable {
    let list: [Book]
}

struct Book: Decodable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    let title: String
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let imageLinks: imageLinksDecode
}

struct imageLinksDecode: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}

struct theBook: Decodable {
    let authors: [String]
    let publisher: String
    let saleInfo: sale
    let selfLink: String
}

struct sale: Decodable {
    let country: String
    let saleability: String
    let isEbook : Bool
    let buyLink : String?
    let listPrice : Prices?
}

struct Prices: Decodable {
    let amount: Double
}
