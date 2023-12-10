//
//  LikesViewController.swift
//

import UIKit
import SnapKit

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let arr = OpenLibraryService()
    private var cardDataArray: [CardData] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CardForLikes.self, forCellReuseIdentifier: "CardForLikes")
        
        let bookDataArray = [
            CardData(dictionary: ["category": "Category 1", "title": "Title 1", "author": "Author 1", "image": "Image"]),
            CardData(dictionary: ["category": "Category 2", "title": "Title 2", "author": "Author 2", "image": "Image"]),
            CardData(dictionary: ["category": "Category 3", "title": "Title 3", "author": "Author 3", "image": "Image"])
        ]
        arr.fetchBookDetails(bookID: "OL66534W") {result in
            switch result {
        case .success(let data):
                print(data)
        case .failure(let error):
            print(error.localizedDescription)
        }
        }
        displayCardViews(with: bookDataArray)
    }
    
    func displayCardViews(with cardDataArray: [CardData]) {
        self.cardDataArray = cardDataArray
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardForLikes", for: indexPath) as? CardForLikes else {
            return UITableViewCell()
        }

        let data = cardDataArray[indexPath.row]
        cell.configure(with: data)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
   
    }





