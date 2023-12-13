//
//  LikesViewController.swift
//

import UIKit
import SnapKit

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let sharedInstance = LikesViewController()
    private let openLibraryService = OpenLibraryService()
    private var booksModel: [BookModel] = []
    private var cardDataArray: [BookModel] = []
    let bookIds = ["OL35351151W", "OL18417W", "OL45804W"]
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        requests()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CardForLikes.self, forCellReuseIdentifier: "CardForLikes")
        
        
    }
    func requests() {
        for i in bookIds {
            openLibraryService.fetchBookCellInfo(with: i, completion: { result in
                switch result {
                case .success(let data):
                    self.booksModel.append(data)
                    print(self.booksModel)
                    print("3")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            })
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardForLikes", for: indexPath) as? CardForLikes else {
            return UITableViewCell()
        }
       
   
    
            cell.title = self.booksModel[indexPath.row].title
            cell.author = self.booksModel[indexPath.row].subjects.first
            
            ImageLoader.loadImage(withCoverID: String(self.booksModel[indexPath.row].covers[0]), size: .L) { image in
                if let image = image {
                    print("==")
                    cell.coverImage = image
                } else {
                    print("Failed to load image")
                }
            }
            tableView.reloadData()
            print(")")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}


