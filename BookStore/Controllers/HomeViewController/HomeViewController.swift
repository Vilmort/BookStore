import UIKit
import OpenLibraryKit
import Kingfisher

final class HomeViewController: UIViewController {
    
    private var searchText: String = ""
    private var coverLoader: ImageLoader?
    private var openLibraryService: OpenLibraryService?
    private var trendingBooks: [TrendingItem] = []
    private var searchingBooks: [SearchResult] = []
    private var sortButtonNames = ["This week", "This Month", "This Year"]
    private var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        applyConstraints()
        sortByNow()
    }
    
    init(coverLoader: ImageLoader, openLibraryService: OpenLibraryService) {
        super.init(nibName: nil, bundle: nil)
        self.coverLoader = coverLoader
        self.openLibraryService = openLibraryService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var topBooksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var recentBooksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var searchBooksField: UITextField = {
        let textfield = UITextField()
        textfield.text = ""
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.textColor = .black
        textfield.placeholder = "Поиск"
        textfield.delegate = self
        textfield.isEnabled = true
        textfield.addTarget(self, action: #selector(textFieldChanged), for: .editingDidEnd)
        return textfield
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "searchLogo"), for: .normal)
        return button
    }()
    
    private lazy var topBooksTitle: UILabel = {
        let label = UILabel()
        label.text = "Top Books"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var topBooksSeeMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "see more"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var buttonCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var recentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Books"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var recentBooksSeeMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "see more"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private func downloadCover(coverId: String) {
        ImageLoader.loadImage(withCoverID: coverId, size: .S) {
            image in
            if let image = image {
                self.images.append(image)
                print(self.images)
            } else {
                print("Failed to load image")
            }
        }
    }
    
    private func sortByNow() {
        openLibraryService?.fetchTrendingBooks(sortBy: .now) { [weak self] result in
            guard let self else { return}
            DispatchQueue.main.async {
                switch result {
                case let .success(books):
                    self.trendingBooks = books
                    self.topBooksCollectionView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
            
        }
    }
    
    @objc func textFieldChanged() {
        searchText = searchBooksField.text ?? ""
        openLibraryService?.fetchSearch(with: searchText) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    self.searchingBooks = data
                    print(data)
                case let .failure(error):
                    print(error)
                }
            }
            
        }
    }
    
    private func addView() {
        [searchBooksField, searchButton, topBooksTitle, topBooksSeeMoreLabel, topBooksCollectionView, recentLabel, recentBooksSeeMoreLabel, recentBooksCollectionView, buttonCollection].forEach(view.setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            searchBooksField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBooksField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            searchBooksField.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.centerYAnchor.constraint(equalTo: searchBooksField.centerYAnchor),
            topBooksTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topBooksTitle.topAnchor.constraint(equalTo: searchBooksField.bottomAnchor, constant: 15),
            topBooksSeeMoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topBooksSeeMoreLabel.centerYAnchor.constraint(equalTo: topBooksTitle.centerYAnchor),
            buttonCollection.leadingAnchor.constraint(equalTo: topBooksTitle.leadingAnchor),
            buttonCollection.topAnchor.constraint(equalTo: topBooksTitle.bottomAnchor, constant: 15),
            buttonCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonCollection.bottomAnchor.constraint(equalTo: topBooksCollectionView.topAnchor,constant: -15),
            topBooksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topBooksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topBooksCollectionView.topAnchor.constraint(equalTo: topBooksTitle.bottomAnchor, constant: 65),
            topBooksCollectionView.bottomAnchor.constraint(equalTo: recentLabel.topAnchor, constant: -15),
            recentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recentLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 445),
            recentBooksSeeMoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recentBooksSeeMoreLabel.centerYAnchor.constraint(equalTo: recentLabel.centerYAnchor),
            recentBooksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recentBooksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recentBooksCollectionView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 20),
            recentBooksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topBooksCollectionView {
            return trendingBooks.count
        } else if collectionView == self.recentBooksCollectionView {
            return 3
        } else if collectionView == self.buttonCollection {
            return 3
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case topBooksCollectionView:
            let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell
            let model = trendingBooks[indexPath.row]
            downloadCover(coverId: "\(String(describing: model.coverId))")
            guard let image = UIImage(named: "mockImage") else { return UICollectionViewCell() }
            topCell?.configureCell(title: model.title,
                                   author: model.authorNames?[0] ?? "Unknown",
                                   genre: "Classics",
                                   image: image )
            return topCell ?? UICollectionViewCell()
        case recentBooksCollectionView:
            let recentCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath)
            return recentCell
        case buttonCollection:
            guard let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
            let model = sortButtonNames[indexPath.row]
            buttonCell.configure(title: model)
            return buttonCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        switch collectionView {
            case topBooksCollectionView:
            return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height)
        case recentBooksCollectionView:
            return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height)
        case buttonCollection:
            return CGSize(width: collectionView.bounds.width / 3 - 10, height: collectionView.bounds.height)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ButtonCollectionViewCell else { return }
        cell.selectedCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ButtonCollectionViewCell else { return }
        cell.deselectedCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        if let cell = buttonCollection.cellForItem(at: IndexPath(row: 0, section: 0)) as? ButtonCollectionViewCell {
//            cell.selectedCell()
//            return true
//        } else {
//            return false
//        }
//    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBooksField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBooksField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchBooksField.text != "" {
            return true
        } else {
            searchBooksField.placeholder = "Поиск"
            return false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
    }
}


