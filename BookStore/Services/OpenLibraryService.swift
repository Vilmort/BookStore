//
//  WebServices.swift
//  BookStore
//
//  Created by Vanopr on 07.12.2023.
//

import Foundation
import OpenLibraryKit

class OpenLibraryService {
    
    private let openLibraryKit = OpenLibraryKit()
    private let networkManager = NetworkManager()

    func fetchTrendingBooks(sortBy category: TrendingCategory,completion: @escaping (Result<[TrendingItem], Error>) -> Void) {
        Task {
            do {
                let data = try await openLibraryKit.trending.trending(category)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchCategory(category: String, completion: @escaping (Result<Subject, Error>) -> Void) {
        Task {
            do {
                let data = try await openLibraryKit.subjects.subject(category)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchBookDetails(bookID: String, completion: @escaping (Result<Work, Error>) -> Void) {
        Task {
            do {
                let data = try await openLibraryKit.books.work(id: bookID)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearch(with query:String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        Task {
            do {
                let data = try await openLibraryKit.search.search(query)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchTrendingLimit10(sortBy category: TrendingCategory, limit: Int,completion: @escaping (Result<MyTrendingModel, Error>) -> Void) {
        Task {
            do {
                let data = try await trendingLimit10(.daily, limit: limit)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchBookCellInfo(with id: String ,completion: @escaping (Result<BookModel, Error>) -> Void) {
        Task {
            do {
                let data = try await bookCellInfo(id: id)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func trendingLimit10(_ target: TrendingCategory, limit: Int) async throws -> MyTrendingModel {
      let urlString = "https://openlibrary.org/trending/\(target.rawValue).json?limit=\(limit)"
      return try await networkManager.request(urlString: urlString)
    }
    
    private func bookCellInfo(id: String) async throws -> BookModel {
      let urlString = "https://openlibrary.org/works/\(id).json"
      return try await networkManager.request(urlString: urlString)
    }

}

//MARK: - How to Fetch Data
/*
 
 let openLibraryService = OpenLibraryService()

 
        openLibraryService.fetchTrendingBooks(sortBy: .daily) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        openLibraryService.fetchCategory(category: "non-fiction") { result in
                        switch result {
                        case .success(let data):
                            print(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
        }
                
        openLibraryService.fetchBookDetails(bookID: "OL45804W") { result in
                                    switch result {
                                    case .success(let data):
                                        print(data)
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                    }
 
 openLibraryService.fetchSearch(with: "Big Boss") { result in
     switch result {
     case .success(let data):
         print(data)
     case .failure(let error):
         print(error.localizedDescription)
     }
 }
 
 
 openLibraryService?.fetchTrendingLimit10(sortBy: .weekly, limit: 1) { result in
     switch result {
     case .success(let data):
         print(data)
     case .failure(let error):
         print(error.localizedDescription)
     }
 }
 
 openLibraryService?.fetchBookCellInfo(with: "OL45804W", completion: { result in
         switch result {
         case .success(let data):
             print(data)
         case .failure(let error):
             print(error.localizedDescription)
         }
 })
 
*/
