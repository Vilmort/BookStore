//
//  CardForLikes.swift
//

import UIKit
import SnapKit
import Foundation

class CardForLikes: UIView {

    private let delButton: UIButton  = {
        let button = UIButton()
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.backgroundColor = .black
        
        return button
    }()
    
    private let RectView: UIView = {
        let rectview = UIView()
        rectview.backgroundColor = .black
        rectview.layer.cornerRadius = 10
        rectview.layer.masksToBounds = true
        
        return rectview
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.textColor = .white
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .left
        
        return imageView
    }()
    
    
    // Step 3: Set up SnapKit layout
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(RectView)
        RectView.addSubview(delButton)
        RectView.addSubview(titleLabel)
        RectView.addSubview(authorLabel)
        RectView.addSubview(coverImageView)
        RectView.addSubview(categoryLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(coverImageView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(8)
        }
        
        RectView.snp.makeConstraints { make in
            make.height.equalTo(coverImageView)

            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel)
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.trailing.equalTo(categoryLabel)
            
        }
        
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.equalTo(titleLabel)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        delButton.snp.makeConstraints { make in
            make.top.equalTo(RectView).offset(10)
            make.trailing.equalTo(RectView).offset(-10)
            make.height.width.equalTo(20)
        }
    }
    
    // Step 5: Configure with book data
    func configure(with data: CardData) {
        categoryLabel.text = data.category
        titleLabel.text = data.title
        authorLabel.text = data.author
        coverImageView.image = UIImage(named: data.image)
    }
}

struct CardData {
    let category: String
    let title: String
    let author: String
    let image: String
    init(dictionary: [String: Any]) {
           category = dictionary["category"] as? String ?? ""
           title = dictionary["title"] as? String ?? ""
           author = dictionary["author"] as? String ?? ""
           image = dictionary["image"] as? String ?? ""
       }
}
