//
//  TrendingModel.swift
//  BookStore
//
//  Created by Vanopr on 14.12.2023.
//

import Foundation


public struct MyTrendingModel: Decodable, Encodable {
    let query: String
    let works: [MyTrendingItem]
}

public struct MyTrendingItem: Decodable, Encodable {
    public let key: String
    public let title: String
    public let editionCount: Int
    public let firstPublishYear: Int?
    public let coverEditionKey: String?
    public let coverId: Int?
    public let languages: [String]?
    public let authorKeys: [String]?
    public let authorNames: [String]?
    
    enum CodingKeys: String, CodingKey {
        case key, title
        case editionCount = "edition_count"
        case firstPublishYear = "first_publish_year"
        case coverEditionKey = "cover_edition_key"
        case coverId = "cover_i"
        case languages = "language"
        case authorKeys = "author_key"
        case authorNames = "author_name"
    }
}
