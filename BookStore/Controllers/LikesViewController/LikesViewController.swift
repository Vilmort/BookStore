//
//  LikesViewController.swift
//

import UIKit
import SnapKit

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let sharedInstance = LikesViewController()
    private let openLibraryService = OpenLibraryService()
    private let likeService = LikeService.shared
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationController?.tabBarController?.tabBar.isHidden = false
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
        return likeService.likedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let books = likeService.likedBooks.reversed()[indexPath.row]
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
        
            likeService.removeElement(likeService.likedBooks.reversed()[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = likeService.likedBooks.reversed()[indexPath.row].id
        let vc = BookDescriptionViewController(bookId: id )
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension LikesViewController: CardForLikesDelegate {
    func deleteButtonTapped(at indexPath: IndexPath) {
        likeService.removeElement(likeService.likedBooks.reversed()[indexPath.row])
        tableView.reloadData()
    }
}
