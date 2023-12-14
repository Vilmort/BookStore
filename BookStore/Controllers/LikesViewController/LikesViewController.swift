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
    
    var bookIds = ["OL35351151W", "OL18417W", "OL45804W"]
    
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
        let dispatchGroup = DispatchGroup()
        for i in bookIds {
            
            dispatchGroup.enter()
            openLibraryService.fetchBookCellInfo(with: i, completion: { result in
                defer {
                    dispatchGroup.leave()
                }
                
                switch result {
                case .success(let data):
                    self.booksModel.append(data)
                    print(self.booksModel.count)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            print("Обновляем")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bookML = self.booksModel[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardForLikes", for: indexPath) as? CardForLikes else {
            return UITableViewCell()
        }
        DispatchQueue.main.async {
            ImageLoader.loadImage(withCoverID: String(bookML.covers[0]), size: .M) { image in
                if let image = image {
                    cell.configure(title: bookML.title, image: image, subjects: bookML.subjects.first ?? "")
                    print("Устанавливаем ячейку")
                } else {
                    print("Failed to load image")
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            bookIds.remove(at: indexPath.last ?? 0)
            booksModel.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
}



