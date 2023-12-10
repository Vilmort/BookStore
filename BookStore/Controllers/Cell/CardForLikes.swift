//
//  CardForLikes.swift
//

import UIKit
import SnapKit
import Foundation

class CardForLikes: UITableViewCell {
    
    private let delButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.backgroundColor = .black
        
        return button
    }()
    
    private let rectView: UIView = {
        let rectView = UIView()
        rectView.backgroundColor = .black
        rectView.layer.cornerRadius = 10
        rectView.layer.masksToBounds = true
        return rectView
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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(rectView)
        rectView.addSubview(delButton)
        rectView.addSubview(titleLabel)
        rectView.addSubview(authorLabel)
        rectView.addSubview(coverImageView)
        rectView.addSubview(categoryLabel)
        
        rectView.snp.makeConstraints { make in
            make.height.equalTo(coverImageView)

                      make.leading.equalToSuperview().offset(20)
                      make.trailing.equalToSuperview().offset(-20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(coverImageView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(8)
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
            make.top.leading.bottom.equalToSuperview()
           
        }
        
        delButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.width.equalTo(20)
        }
    }
    
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
