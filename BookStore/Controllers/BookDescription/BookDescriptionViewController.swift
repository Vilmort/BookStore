//
//  BookDeskriptionViewController.swift
//  BookStore
//
//  Created by Юрий on 11.12.2023.
//

import UIKit

class BookDescriptionViewController: UIViewController {

    //MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var bookNameLabel: UILabel = {
        labelCreation(with: "The Picture of Dorian Gray", fontSize: 32, fontWeight: .bold)
    }()
    
    private let bookImage: UIImageView = {
        let bookImage = UIImageView()
        
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        return bookImage
    }()
    
    private lazy var authorLabel: UILabel = {
        labelCreation(with: "Author:", fontSize: 16, fontWeight: .medium)
    }()
    
    private lazy var authorNameLabel: UILabel = {
        labelCreation(with: "Oscar Wilde", fontSize: 16, fontWeight: .bold)
    }()
    
    private lazy var categoryLabel: UILabel = {
        labelCreation(with: "Category:", fontSize: 16, fontWeight: .medium)
    }()
    
    private lazy var categoryNameLabel: UILabel = {
        labelCreation(with: "Classics", fontSize: 16, fontWeight: .bold)
    }()
    
    private lazy var ratingLabel: UILabel = {
        labelCreation(with: "Rating:", fontSize: 16, fontWeight: .medium)
    }()
    
    private lazy var bookRatingLabel: UILabel = {
        labelCreation(with: "4.11/5", fontSize: 16, fontWeight: .bold)
    }()
    
    private lazy var descriptionLabel: UILabel = {
        labelCreation(with: "Description:", fontSize: 16, fontWeight: .bold)
    }()
    
    private lazy var bookDescriptionLAbel: UILabel = {
        labelCreation(with: "Some book description", fontSize: 16, fontWeight: .regular)
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan

    }
    
    //MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(bookImage)
    }
    
    private func labelCreation(with text: String, fontSize: CGFloat, fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        return label
    }
    
    private func setDelegates() {
        scrollView.delegate = self
    }
    
    
    
    

}

// MARK: - UIScrollViewDelegate

extension BookDescriptionViewController: UIScrollViewDelegate {
    
}

// MARK: - Set Constraints

extension BookDescriptionViewController {
    func setConstraints() {
        
    }
}

