//
//  RealmModel.swift
//  BookStore
//
//  Created by Vanopr on 15.12.2023.
//

import RealmSwift
import UIKit


struct Book: Equatable {
    let id: String
    let title: String
    let image: UIImage
    let category: String
}

class BooksList: Object {
    let recentBooks = List<BookRealm>()
    let likedBooks = List<BookRealm>()
}

class BookRealm: Object {
    @Persisted var id: String = ""
    @Persisted var title: String = ""
    @Persisted var imageData: Data?
    @Persisted var category: String = ""
}
