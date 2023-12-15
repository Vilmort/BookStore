//
//  SaveToRealmService.swift
//  BookStore
//
//  Created by Vanopr on 15.12.2023.
//

import Foundation
import RealmSwift
import UIKit


struct RealmManager {
    private let likeService = LikeService.shared
    private let recentService = RecentService.shared
    
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    // Сохранение в Realm
    private func saveBooks(recentBooks: [Book], likedBooks: [Book]) {
        do {
               try realm.write {
                   // Пытаемся получить существующий объект BooksList
                   if let existingBooksList = realm.objects(BooksList.self).first {
                       // Очищаем текущие списки и заполняем их заново
                       existingBooksList.recentBooks.removeAll()
                       existingBooksList.likedBooks.removeAll()

                       // Заполняем List из массива объектов BookRealm для Recent
                       recentBooks.forEach { book in
                           let bookRealm = BookRealm()
                           bookRealm.id = book.id
                           bookRealm.title = book.title
                           bookRealm.imageData = book.image.pngData()
                           bookRealm.category = book.category
                           existingBooksList.recentBooks.append(bookRealm)
                       }

                       // Заполняем List из массива объектов BookRealm для like
                       likedBooks.forEach { book in
                           let bookRealm = BookRealm()
                           bookRealm.id = book.id
                           bookRealm.title = book.title
                           bookRealm.imageData = book.image.pngData()
                           bookRealm.category = book.category
                           existingBooksList.likedBooks.append(bookRealm)
                       }
                   } else {
                       // Если объекта BooksList еще нет, создаем новый и добавляем его в Realm
                       let booksLists = BooksList()

                       // Заполняем List из массива объектов BookRealm для Recent
                       recentBooks.forEach { book in
                           let bookRealm = BookRealm()
                           bookRealm.id = book.id
                           bookRealm.title = book.title
                           bookRealm.imageData = book.image.pngData()
                           bookRealm.category = book.category
                           booksLists.recentBooks.append(bookRealm)
                       }

                       // Заполняем List из массива объектов BookRealm для like
                       likedBooks.forEach { book in
                           let bookRealm = BookRealm()
                           bookRealm.id = book.id
                           bookRealm.title = book.title
                           bookRealm.imageData = book.image.pngData()
                           bookRealm.category = book.category
                           booksLists.likedBooks.append(bookRealm)
                       }

                       // Добавляем новый объект BooksList в Realm
                       realm.add(booksLists)
                   }
               }
           } catch {
               print("Failed to save recent books to Realm: \(error.localizedDescription)")
           }
        }

        // Получение из Realm
    private  func getRecentBooks() -> [Book] {
            guard let recentBooksList = realm.objects(BooksList.self).first else {
                return []
            }
            return recentBooksList.recentBooks.map { bookRealm in
                Book(
                    id: bookRealm.id,
                    title: bookRealm.title,
                    image: UIImage(data: bookRealm.imageData ?? Data()) ?? UIImage(),
                    category: bookRealm.category
                )
            }
        }
    
    private func getLikedBooks() -> [Book] {
        guard let recentBooksList = realm.objects(BooksList.self).first else {
            return []
        }
        return recentBooksList.likedBooks.map { bookRealm in
            Book(
                id: bookRealm.id,
                title: bookRealm.title,
                image: UIImage(data: bookRealm.imageData ?? Data()) ?? UIImage(),
                category: bookRealm.category
            )
        }
    }
    
    
    
    
     func saveToRealm() {
        let likeBooks = likeService.likedBooks
        let recentBooks = recentService.recentBooks
        saveBooks(recentBooks: recentBooks, likedBooks: likeBooks)
    }
    
     func getFromRealm() {
        likeService.likedBooks = getLikedBooks()
        recentService.recentBooks = getRecentBooks()
    }
}
