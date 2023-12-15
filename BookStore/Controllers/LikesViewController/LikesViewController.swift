//
//  LikesViewController.swift
//

import UIKit
import SnapKit

class LikesViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "blackAndWhite")
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Step 7: Retrieve book data from API or any other source
        let bookDataArray = [
            CardData(dictionary: ["category": "Category 1", "title": "Title 1", "author": "Author 1", "image": "Image"]),
            CardData(dictionary: ["category": "Category 2", "title": "Title 2", "author": "Author 2", "image": "Image 2"]),
            CardData(dictionary: ["category": "Category 3", "title": "Title 3", "author": "Author 3", "image": "Image 3"])
        ]
        
        displayCardViews(with: bookDataArray)
    }
    
    func displayCardViews(with cardDataArray: [CardData]) {
        for (index, data) in cardDataArray.enumerated() {
            let cardView = CardForLikes()
            cardView.configure(with: data)
            
            scrollView.addSubview(cardView)
            
            cardView.snp.makeConstraints { make in
                make.width.equalTo(scrollView).inset(20)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(index * 250 + 20)
                
                
                if index == cardDataArray.count - 1 {
                    make.bottom.equalToSuperview().inset(20)
                }
            }
        }
        
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(cardDataArray.count) * 250 + 40)
    }
}
