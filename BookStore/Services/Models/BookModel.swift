//
//  BookModel.swift
//  BookStore
//
//  Created by Vanopr on 13.12.2023.
//

import Foundation




struct BookModel: Decodable {
     let title: String
     let covers: [Int]
     let subjects: [String]
}
