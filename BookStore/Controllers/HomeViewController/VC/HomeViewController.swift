import UIKit
import OpenLibraryKit
import Kingfisher

final class HomeViewController: UIViewController {
    
    private (set) var searchText: String = ""
    private var coverLoader: ImageLoader?
    private var openLibraryService: OpenLibraryService?
    private var trendingBooks: [TrendingItem] = []
    private var searchingBooks: [SearchResult] = []
    private var sortButtonNames = ["This Week", "This Month", "This Year"]
    private (set) var images: [UIImage] = []
    let index : IndexPath = IndexPath(index: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        applyConstraints()
        sortByWeekly()
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
        collectionView.register(TopBooksCollectionViewCell.self, forCellWithReuseIdentifier: TopBooksCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var recentBooksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecentBooksCollectionViewCell.self, forCellWithReuseIdentifier: RecentBooksCollectionViewCell.identifier)
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
        textfield.placeholder = "Type somethings"
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
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search books:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.isHidden = true
        return label
    }()
    
    private lazy var searchBookCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchBooksCollectionViewCell.self, forCellWithReuseIdentifier: SearchBooksCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        button.isHidden = true
        button.addTarget(self, action: #selector(backTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var plugImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "searchError")
        image.isHidden = true
        return image
    }()
    
    private func downloadCover(coverId: String) {
        ImageLoader.loadImage(withCoverID: coverId, size: .S) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                if let image = image {
                    self.images.append(image)
                    print(self.images)
                } else {
                    print("Failed to load image")
                }
            }
        }
    }
    
    private func sortByWeekly() {
        UIBlockingProgressHUD.show()
        openLibraryService?.fetchTrendingBooks(sortBy: .weekly) { [weak self] result in
            guard let self else { return}
            DispatchQueue.main.async {
                switch result {
                case let .success(books):
                    self.trendingBooks = books
                    self.topBooksCollectionView.reloadData()
                case let .failure(error):
                    UIBlockingProgressHUD.dismiss()
                    print(error)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func sortByMothly() {
        UIBlockingProgressHUD.show()
        openLibraryService?.fetchTrendingBooks(sortBy: .monthly) { [weak self] result in
            guard let self else { return}
            DispatchQueue.main.async {
                switch result {
                case let .success(books):
                    self.trendingBooks = books
                    self.topBooksCollectionView.reloadData()
                case let .failure(error):
                    UIBlockingProgressHUD.dismiss()
                    print(error)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func sortByYearly() {
        UIBlockingProgressHUD.show()
        openLibraryService?.fetchTrendingBooks(sortBy: .yearly) { [weak self] result in
            guard let self else { return}
            DispatchQueue.main.async {
                switch result {
                case let .success(books):
                    self.trendingBooks = books
                    self.topBooksCollectionView.reloadData()
                case let .failure(error):
                    UIBlockingProgressHUD.dismiss()
                    print(error)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    
    @objc func textFieldChanged() {
        searchText = searchBooksField.text ?? ""
        UIBlockingProgressHUD.show()
        openLibraryService?.fetchSearch(with: searchText) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    if self.searchingBooks.isEmpty {
                        self.plugImage.isHidden = false
                        self.hideUI()
                        UIBlockingProgressHUD.dismiss()
                    } else {
                        self.searchingBooks = data
                        print(data)
                        self.hideUI()
                        self.searchBookCollection.reloadData()
                        UIBlockingProgressHUD.dismiss()
                    }
                case let .failure(error):
                    print(error)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    @objc func backTapButton() {
        print("tap")
        showUI()
    }
    
    private func hideUI() {
        [topBooksTitle, topBooksSeeMoreLabel, topBooksCollectionView, recentLabel, recentBooksCollectionView, recentBooksSeeMoreLabel, buttonCollection].forEach { view in
            view.isHidden = true
        }
        searchLabel.isHidden = false
        searchBookCollection.isHidden = false
        backButton.isHidden = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchLabel.topAnchor.constraint(equalTo: searchBooksField.bottomAnchor, constant: 20),
            searchBookCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBookCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBookCollection.topAnchor.constraint(equalTo: searchLabel.topAnchor, constant: 35),
            searchBookCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    private func showUI() {
        [topBooksTitle, topBooksSeeMoreLabel, topBooksCollectionView, recentLabel, recentBooksCollectionView, recentBooksSeeMoreLabel, buttonCollection].forEach { view in
            view.isHidden = false
        }
        searchLabel.isHidden = true
        searchBookCollection.isHidden = true
        backButton.isHidden = true
    }
    
    private func addView() {
        [searchBooksField, searchButton, topBooksTitle, topBooksSeeMoreLabel, topBooksCollectionView, recentLabel, recentBooksSeeMoreLabel, recentBooksCollectionView, buttonCollection, searchLabel, searchBookCollection, backButton, plugImage].forEach(view.setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            searchBooksField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBooksField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            searchBooksField.topAnchor.constraint(equalTo: view.topAnchor, constant: 115),
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
            recentLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 480),
            recentBooksSeeMoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recentBooksSeeMoreLabel.centerYAnchor.constraint(equalTo: recentLabel.centerYAnchor),
            recentBooksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recentBooksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recentBooksCollectionView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 20),
            recentBooksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            plugImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330),
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
        } else if collectionView == self.searchBookCollection{
            return searchingBooks.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case topBooksCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopBooksCollectionViewCell.identifier, for: indexPath) as? TopBooksCollectionViewCell
            let model = trendingBooks[indexPath.row]
            //let images = images[indexPath.row]
            //downloadCover(coverId: "\(String(describing: model.coverId))")
            guard let image = UIImage(named: "mockImage") else { return UICollectionViewCell() }
            cell?.configureCell(title: model.title,
                                author: model.authorNames?[0] ?? "Unknown",
                                genre: "Classics",
                                image: image )
            return cell ?? UICollectionViewCell()
        case recentBooksCollectionView:
            let recentCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentBooksCollectionViewCell.identifier, for: indexPath)
            return recentCell
        case buttonCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
            let model = sortButtonNames[indexPath.row]
            cell.configure(title: model)
            return cell
        case searchBookCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchBooksCollectionViewCell.identifier, for: indexPath) as? SearchBooksCollectionViewCell
            let model = searchingBooks[indexPath.row]
            cell?.configureCell(title: model.title, author: model.authors?[0] ?? "Unknown", genre: "Classics")
            return cell ?? UICollectionViewCell()
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
        case searchBookCollection:
            return CGSize(width: collectionView.bounds.width / 2.4 + 23, height: collectionView.bounds.height / 2.5 + 10)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case topBooksCollectionView:
            return 10
        case recentBooksCollectionView:
            return 10
        case searchBookCollection:
            return 10
        case buttonCollection:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ButtonCollectionViewCell else { return }
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            sortByWeekly()
            cell.selectedCell()
        case IndexPath(row: 1, section: 0):
            cell.selectedCell()
            sortByMothly()
        case IndexPath(row: 2, section: 0):
            cell.selectedCell()
            sortByYearly()
        default: break
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ButtonCollectionViewCell else { return }
        cell.deselectedCell()
    }
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
            searchBooksField.placeholder = "Type somethings"
            return false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
}


