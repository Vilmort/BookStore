//
//  CategoryCell.swift
//  BookStore
//
//  Created by Vanopr on 17.12.2023.
//

import UIKit


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
