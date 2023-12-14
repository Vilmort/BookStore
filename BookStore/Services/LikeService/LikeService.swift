//
//  LikeService.swift
//  BookStore
//
//  Created by Vanopr on 14.12.2023.
//

import Foundation

class LikeService {
    static let shared = LikeService()
    var likedBooks: [String] = []
    
    func appendElement(_ element: String) {
        if let index = likedBooks.firstIndex(of: element) {
            likedBooks.remove(at: index)
        }
        likedBooks.append(element)
    }
    
    func removeElement(_ element: String) {
        if let index = likedBooks.firstIndex(of: element) {
            likedBooks.remove(at: index)
        }
    }
    
    func ifElementLiked(_ element: String) -> Bool {
        return likedBooks.contains(element)
    }
    
}
