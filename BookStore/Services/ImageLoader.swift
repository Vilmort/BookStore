//
//  ImageLoader.swift
//  BookStore
//
//  Created by Vanopr on 07.12.2023.
//

import Foundation


import UIKit
import Kingfisher

struct ImageLoader {
    
    enum SizeOfImage: String {
        case S = "S"
        case M = "M"
        case L = "L"
    }
    
   static func loadImage(withCoverID coverID: String,size: SizeOfImage, completion: @escaping (UIImage?) -> Void) {
        
        let urlString = "https://covers.openlibrary.org/b/id/\(coverID)-\(size.rawValue).jpg"
        
        if let url = URL(string: urlString) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    completion(value.image)
                case .failure:
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }

}

//MARK: - How to Fetch Image

//        ImageLoader.loadImage(withCoverID: "12403233", size: .L) { image in
//            if let image = image {
//                   print("Successfully loaded image")
//               } else {
//                   print("Failed to load image")
//               }
//        }
