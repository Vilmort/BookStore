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
*/
