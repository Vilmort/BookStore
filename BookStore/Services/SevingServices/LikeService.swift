//
//  LikeService.swift
//  BookStore
//
//  Created by Vanopr on 14.12.2023.
//

import Foundation

class LikeService {
    static let shared = LikeService()
    var likedBooks: [Book] = []

    func appendElement(_ element: Book) {
        likedBooks.append(element)
    }
    
    func removeElement(_ element: Book) {
        for book in likedBooks {
            guard book.id.contains(element.id),
                  let index = likedBooks.firstIndex(of: book) else { continue }
            likedBooks.remove(at: index)
        }
    }
    
    func ifElementLiked(_ element: String) -> Bool {
        for book in likedBooks {
            if book.id.contains(element) {
                        return true
                    }
        }
        return false
    }
    
}
