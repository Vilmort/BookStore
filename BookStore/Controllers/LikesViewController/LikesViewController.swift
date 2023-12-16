//
//  LikesViewController.swift
//

import UIKit
import SnapKit

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let sharedInstance = LikesViewController()
    private let openLibraryService = OpenLibraryService()
    private let likeservice = LikeService.shared
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CardForLikes.self, forCellReuseIdentifier: "CardForLikes")
        
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeservice.likedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let books = likeservice.likedBooks.reversed()[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardForLikes", for: indexPath) as? CardForLikes else {
            return UITableViewCell()
        }
        
        cell.configure(title: books.title, image: books.image, subjects: books.category, indexPath: indexPath, delegate: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            likeservice.removeElement(likeservice.likedBooks.reversed()[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            
    }
}


extension LikesViewController: CardForLikesDelegate {
    func deleteButtonTapped(at indexPath: IndexPath) {
        likeservice.removeElement(likeservice.likedBooks.reversed()[indexPath.row])
        tableView.reloadData()
    }
}
