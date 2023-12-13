//
//  BookDeskriptionViewController.swift
//  BookStore
//
//  Created by Юрий on 11.12.2023.
//

import UIKit
import OpenLibraryKit

class BookDescriptionViewController: UIViewController {
    
    private var isLiked = false
    
    private let openLibraryService = OpenLibraryService()
    var bookId: String? {
        didSet {
            fetchBookDetails(id: bookId)
        }
        
    }
    
    //MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var bookNameLabel: UILabel = {
        createLabel(with: "The Picture of Dorian Gray", fontSize: 30, fontWeight: .bold)
    }()
    
    private let bookImage: UIImageView = {
        let bookImage = UIImageView()
        bookImage.image = #imageLiteral(resourceName: "Group")
        bookImage.contentMode = .scaleAspectFit
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        return bookImage
    }()
    
    private lazy var authorLabel: UILabel = {
        createLabel(with: "Author:", fontSize: 16, fontWeight: .medium)
    }()
    
    private lazy var authorNameLabel: UILabel = {
        createLabel(with: "Oscar Wilde", fontSize: 16, fontWeight: .bold)
    }()
    
    private lazy var categoryLabel: UILabel = {
        createLabel(with: "Category:", fontSize: 16, fontWeight: .medium)
    }()
    
    private lazy var categoryNameLabel: UILabel = {
        createLabel(with: "Classics", fontSize: 16, fontWeight: .bold)
    }()
    
    private lazy var ratingLabel: UILabel = {
        createLabel(with: "Rating:", fontSize: 16, fontWeight: .medium)
    }()
    
    private lazy var bookRatingLabel: UILabel = {
        createLabel(with: "4.11/5", fontSize: 16, fontWeight: .bold)
    }()
    
    private lazy var descriptionLabel: UILabel = {
        createLabel(with: "Description:", fontSize: 16, fontWeight: .bold)
    }()
    
    private lazy var bookDescriptionLabel: UILabel = {
        let label = createLabel(with: "Some book description: Oscar Wilde's only novel is the dreamlike story of a young man who sells his soul for eternal youth and beauty. In this celebrated work Wilde forged a devastating portrait of the effects of evil and debauchery on a young aesthete in late-19th-century England. Combining elements of the Gothic horror novel and decadent French fiction, the book centers on a striking premise: As Dorian Gray sinks into a life of crime and gross sensuality, his body retains perfect youth and vigor while his recently painted portrait grows day by day into a hideous record of evil, which he Oscar Wilde's only novel is the dreamlike story of a young man who sells his soul for eternal youth and beauty. In this celebrated work Wilde forged a devastating portrait of the effects of evil and debauchery on a young aesthete in late-19th-century England. Combining elements of the Gothic horror novel and decadent French fiction, the book centers on a striking premise: As Dorian Gray sinks into a life of crime and gross sensuality, his body retains perfect youth and vigor while his recently painted portrait grows day by day into a hideous record of evil, which he Oscar Wilde's only novel is the dreamlike story of a young man who sells his soul for eternal youth and beauty. In this celebrated work Wilde forged a devastating portrait of the effects of evil and debauchery on a young aesthete in late-19th-century England. Combining elements of the Gothic horror novel and decadent French fiction, the book centers on a striking premise: As Dorian Gray sinks into a life of crime and gross sensuality, his body retains perfect youth and vigor while his recently painted portrait grows day by day into a hideous record of evil, which he", fontSize: 16, fontWeight: .regular)
        
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var authorStackView: UIStackView = {
        createStack(arrangedSubviews: [authorLabel, authorNameLabel], axis: .horizontal)
    }()
    
    private lazy var categoryStackView: UIStackView = {
        createStack(arrangedSubviews: [categoryLabel, categoryNameLabel], axis: .horizontal)
    }()
    
    private lazy var ratingStackView: UIStackView = {
        createStack(arrangedSubviews: [ratingLabel, bookRatingLabel], axis: .horizontal)
    }()
    
    private lazy var verticalStack: UIStackView = {
        createStack(arrangedSubviews: [authorStackView, categoryStackView, ratingStackView], axis: .vertical)
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLiked = UserDefaults.standard.bool(forKey: "isLiked")
    
            if isLiked {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            }
        setupNavigationBar()
        setupViews()
        setConstraints()
        
        
    }
}

//MARK: - Private Methods

private extension BookDescriptionViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(bookNameLabel)
        contentView.addSubview(bookImage)
        contentView.addSubview(verticalStack)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(bookDescriptionLabel)
    }
    
    func setupUI(with data: Work) {
        //authorNameLabel.text = data.subjectPeople
        DispatchQueue.main.async {
            self.categoryNameLabel.text = data.subjects[0]
            //bookRatingLabel.text = data.
            self.bookNameLabel.text = data.title
            self.bookDescriptionLabel.text = data.bookDescription.debugDescription
            ImageLoader.loadImage(withCoverID: "\(data.covers[0])", size: .M) { image in
                if let myImage = image {
                    self.bookImage.image = myImage
                    print("Successfully loaded image")
                } else {
                    print("Failed to load image")
                }
            }
            self.view.reloadInputViews()
        }
    }
    
    func createLabel(with text: String, fontSize: CGFloat, fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createStack(arrangedSubviews views: [UIView], axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Classics"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeButtonTapped))
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc func backButtonTapped() {
        print("back")
    }
    
    @objc func likeButtonTapped() {
        
        isLiked = !isLiked
        
        UserDefaults.standard.set(isLiked, forKey: "isLiked")
        
        if isLiked {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
//            UserDefaults.standard.set(false, forKey: "isLiked")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
//            UserDefaults.standard.set(true, forKey: "isLiked")
        }
        
        print("like")
    }
    //"OL45804W"
    func fetchBookDetails(id: String?) {
        guard let id else { return }
        openLibraryService.fetchBookDetails(bookID: id) { result in
            switch result {
            case .success(let data):
                self.setupUI(with: data)
                
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


// MARK: - Set Constraints

extension BookDescriptionViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bookNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            bookNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bookNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            bookImage.topAnchor.constraint(equalTo: bookNameLabel.bottomAnchor, constant: 15),
            bookImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            verticalStack.topAnchor.constraint(equalTo: bookNameLabel.bottomAnchor, constant: 25),
            verticalStack.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 15),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
            
            bookDescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bookDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bookDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

