//
//  BookCategoryViewController.swift
//  BookStore
//
//  Created by Alex  on 12.12.2023.
//

import UIKit
import Kingfisher
import OpenLibraryKit
import SnapKit

// MARK: - ПАТТЕРН ДЛЯ ОБЩЕГО ПРЕДСТАВЛЕНИЯ ВСЕХ ЭКРАНОВ КАТЕГОРИЙ
class BookCategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	private var collectionView: UICollectionView!
	private var books: [SubjectWork] = [] //  модель SubjectWork

	private let openLibraryService = OpenLibraryService()
	private let category: String

	init(category: String) {
		self.category = category
		super.init(nibName: nil, bundle: nil)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		self.category = "" // Assign some default value, or handle it appropriately
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = true
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		myCollectionView()
		loadBooks()
	}

	func loadBooks() {
		UIBlockingProgressHUD.show()
		openLibraryService.fetchCategory(category: category) { result in
			DispatchQueue.main.async {
				switch result {
				case .success(let subject):
					self.books = subject.works
					self.collectionView.reloadData()
				case .failure(let error):
					print("Error loading books: \(error)")
				}
				DispatchQueue.main.async {
					UIBlockingProgressHUD.dismiss()
				}
			}
		}
	}

	func myCollectionView() {
		let layout = UICollectionViewFlowLayout()
		let cellWidth = (view.frame.width - 60) / 2
		layout.itemSize = CGSize(width: cellWidth, height: 220)
		layout.minimumInteritemSpacing = 20
		layout.minimumLineSpacing = 5

		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCell")

		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(50)
			make.leading.trailing.equalToSuperview().inset(20)
			make.bottom.equalToSuperview().offset(-60)
		}
	}
    
    private func removeSubstringFromWorks(_ input: String) -> String {
         return input.replacingOccurrences(of: "/works/", with: "")
     }

	// MARK: - UICollectionViewDataSource

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return books.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as? BookCollectionViewCell else {
			fatalError("Unable to dequeue BookCollectionViewCell")
		}

		let book = books[indexPath.item]
		cell.titleLabel.text = book.title
		cell.titleLabel.lineBreakMode = .byTruncatingTail

		let coverID = book.coverId

		if coverID != 0 {
			ImageLoader.loadImage(withCoverID: "\(coverID)", size: .M) { image in
				cell.coverImageView.image = image
			}
		}
		return cell
	}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.item]
        let id = removeSubstringFromWorks(book.key)
        let vc = BookDescriptionViewController(bookId: id )
        navigationController?.pushViewController(vc, animated: true)
    }
}
