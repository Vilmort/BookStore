//
//  RecentService.swift
//  BookStore
//
//  Created by Vanopr on 15.12.2023.
//

import Foundation

class RecentService {
    
    static let shared = RecentService()
    var recentBooks: [Book] = []
    
    func appendElement(_ element: Book) {
        for book in recentBooks {
            guard book.id.contains(element.id),
                  let index = recentBooks.firstIndex(of: book) else { continue }
            recentBooks.remove(at: index)
        }
        
        if recentBooks.count >= 10 {
                recentBooks.removeFirst() 
            }
        
        recentBooks.append(element)
    }
    
}
