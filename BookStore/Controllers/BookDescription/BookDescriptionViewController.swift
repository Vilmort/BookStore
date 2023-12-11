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
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var bookNameLabel: UILabel = {
        labelCreation(with: "The Picture of Dorian Gray", fontSize: 32, fontWeight: .bold)
    }()
    
    private let bookImage: UIImageView = {
        let bookImage = UIImageView()
        bookImage.image = #imageLiteral(resourceName: "Group")
        bookImage.contentMode = .scaleAspectFit
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
    
    private lazy var bookDescriptionLabel: UILabel = {
        labelCreation(with: "Some book description", fontSize: 16, fontWeight: .regular)
    }()
    
    private lazy var authorStackView: UIStackView = {
        createStack(arrangedSubviews: [authorLabel, authorNameLabel], axis: .horizontal, spacing: 5)
    }()
    
    private lazy var categoryStackView: UIStackView = {
        createStack(arrangedSubviews: [categoryLabel, categoryNameLabel], axis: .horizontal, spacing: 5)
    }()
    
    private lazy var ratingStackView: UIStackView = {
        createStack(arrangedSubviews: [ratingLabel, bookRatingLabel], axis: .horizontal, spacing: 5)
    }()
    
    private lazy var verticalStack: UIStackView = {
        createStack(arrangedSubviews: [authorStackView, categoryStackView, ratingStackView], axis: .vertical, spacing: 10)
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        //setDelegates()
        setConstraints()

    }
    
    //MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(bookImage)
        scrollView.addSubview(bookNameLabel)
        scrollView.addSubview(verticalStack)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(bookDescriptionLabel)
    }
    
    private func labelCreation(with text: String, fontSize: CGFloat, fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createStack(arrangedSubviews views: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
          stackView.axis = axis
          stackView.spacing = spacing
          stackView.translatesAutoresizingMaskIntoConstraints = false
          return stackView
    }
    
//    private func setDelegates() {
//        scrollView.delegate = self
//    }
}

// MARK: - UIScrollViewDelegate

//extension BookDescriptionViewController: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        targetContentOffset.pointee = CGPoint(x: targetContentOffset.pointee.x, y: 0)
//    }
//}

// MARK: - Set Constraints

extension BookDescriptionViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bookNameLabel.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 15),
            bookNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            bookNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            
            bookImage.topAnchor.constraint(equalTo: bookNameLabel.bottomAnchor, constant: 15),
            bookImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            bookImage.heightAnchor.constraint(equalToConstant: 250),
            
            verticalStack.topAnchor.constraint(equalTo: bookNameLabel.bottomAnchor, constant: 25),
            verticalStack.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 15),
            verticalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: 10),
            
            bookDescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            bookDescriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            bookDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15)
            
        ])
    }
}

