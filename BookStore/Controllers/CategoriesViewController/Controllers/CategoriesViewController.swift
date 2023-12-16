//
//  CategoriesViewController.swift
//  BookStore
//
//  Created by Vanopr on 02.12.2023.
//

import UIKit
import SnapKit
import OpenLibraryKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	private let openLibraryService = OpenLibraryService()
	private var searchResultsViewController: SearchResultsViewController?
	
	
	private lazy var searchTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Search title/author"
		textField.borderStyle = .roundedRect
		return textField
	}()
	
	lazy var searchButton: UIButton = { 
		let button = UIButton()
		button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
		button.addTarget(self, action: #selector(self.searchButtonTapped), for: .touchUpInside)
		return button
	}()
	
	lazy var filterButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "filterIcon"), for: .normal) 
		button.addTarget(self, action: #selector(self.filterButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private lazy var searchStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [searchTextField, searchButton, filterButton])
		stackView.spacing = 8
		stackView.alignment = .center
		return stackView
	}()
	
	private let labelCategories: UILabel = {
		let label = UILabel()
		label.text = "Categories"
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: 28.0, weight: .medium)
		label.textColor = UIColor.black
		return label
	}()

	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .clear
		collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
		collectionView.showsVerticalScrollIndicator = false
		return collectionView
	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
	}

	override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = .systemBackground

		addViews()
		setupViews()
	}
	
	@objc func searchButtonTapped() {
		print("tauch")
		guard let query = searchTextField.text, !query.isEmpty else {
			return
		}
		
		UIBlockingProgressHUD.show()
		DispatchQueue.main.async { [self] in
			openLibraryService.fetchSearch(with: query) { [weak self] result in
				switch result {
				case .success(let searchResults):
					self?.showSearchResults(searchResults)
					print("FIRE")
				case .failure(let error):
					print("Search failed: \(error.localizedDescription)")
				}
				DispatchQueue.main.async {
					UIBlockingProgressHUD.dismiss()
				}
		   }
		}
	}
	
	private func showSearchResults(_ results: [SearchResult]) {
		DispatchQueue.main.async { [weak self] in
			if self?.searchResultsViewController == nil {
				self?.searchResultsViewController?.title = "Search Results"
				self?.searchResultsViewController = SearchResultsViewController()
				self?.navigationController?.pushViewController(self?.searchResultsViewController ?? UIViewController(), animated: true)
			}
			self?.searchResultsViewController?.updateSearchResults(results: results)
			print("Search results count: \(results.count)") // Добавим этот вывод в консоль
			//  вывод в консоль для проверки заголовка
			print("Search results view controller title: \(self?.searchResultsViewController?.title ?? "No title")")
			
		}
	}
	
	@objc func filterButtonTapped() {
		print("tauch")
		searchResultsViewController?.sortedResult()
	}

	func setupViews() {
		collectionView.dataSource = self
		collectionView.delegate = self

		searchStackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(82)
			make.leading.trailing.equalToSuperview().inset(20)
			//make.height.equalTo(56)
		}
		
		labelCategories.snp.makeConstraints { make in
			make.top.equalTo(searchStackView.snp.bottom).offset(32)
			make.leading.trailing.equalToSuperview().inset(20)
			make.height.equalTo(28)
		}
		
		collectionView.snp.makeConstraints { make in
			make.top.equalTo(labelCategories.snp.bottom).offset(22)
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(15) // Отступ снизу от UITabBarController
			make.leading.trailing.equalToSuperview()//.inset(20)
		}
	}

	func addViews() {
		view.addSubview(searchStackView)
		view.addSubview(collectionView)
		view.addSubview(labelCategories)
	}

	// MARK: - UICollectionViewDataSource

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return CategoriesNameModel.names.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
			return UICollectionViewCell()
		}

		cell.imageView.image = UIImage(named: CategoriesImagesModel.images[indexPath.item])
		cell.imageView.contentMode = .scaleAspectFit // Оригинальный размер изображения

		return cell
	}

	// MARK: - UICollectionViewDelegateFlowLayout

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.frame.width - 3 * 20) / 2 // Размер ячейки, учитывая отступы
		let height = (collectionView.frame.height - 3 * 20) / 4 // Пропорциональная высота
		return CGSize(width: width, height: height)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // Отступы между ячейками и краями collectionView
	}

	// MARK: - UICollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedViewController = BookCategoryViewController(category: CategoriesNameModel.names[indexPath.item])
		navigationController?.pushViewController(selectedViewController, animated: true)
	}
}

// Кастомная ячейка для изображений категорий
class CategoryCell: UICollectionViewCell {
	static let reuseIdentifier = "CategoryCell"

	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		return imageView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupViews() {
		addSubview(imageView)
		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
