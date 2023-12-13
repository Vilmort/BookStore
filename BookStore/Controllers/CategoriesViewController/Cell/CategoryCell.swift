//
//  CategoryCell.swift
//  BookStore
//
//  Created by Alex  on 13.12.2023.
//


import UIKit


class BookCollectionViewCell: UICollectionViewCell {

	let coverImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		return imageView
	}()

	let titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 2
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		addSubview(coverImageView)
		addSubview(titleLabel)

		coverImageView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(150)
		}

		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(coverImageView.snp.bottom).offset(3)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
}

