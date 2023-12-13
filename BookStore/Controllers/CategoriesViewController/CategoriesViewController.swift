//
//  CategoriesViewController.swift
//  BookStore
//
//  Created by Vanopr on 02.12.2023.
//

import UIKit
import SnapKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		addViews()
		setupViews()
	}

	func setupViews() {
		collectionView.dataSource = self
		collectionView.delegate = self

		//view.addSubview(labelCategories)
		labelCategories.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(168)
			make.leading.trailing.equalToSuperview().inset(20)
			make.height.equalTo(28)
		}

		//view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.top.equalTo(labelCategories.snp.bottom).offset(32)
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(15) // Отступ снизу от UITabBarController
			make.leading.trailing.equalToSuperview()//.inset(20)
		}
	}

	func addViews() {
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

		let category = CategoriesNameModel.names[indexPath.item]
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
