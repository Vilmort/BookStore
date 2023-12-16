import UIKit
import OpenLibraryKit

final class SeeMoreViewController: UIViewController {
  
    private var coverLoader = ImageLoader()
    private var openLibraryService = OpenLibraryService()
    private var recentService = RecentService.shared
    private var searchingBooks: [SearchResult] = []
    private var sortButtonNames = ["This Week", "This Month", "This Year"]
    private var recentBooks: [Book] = []
    private var images = [UIImage]() {
        didSet {
            if images.count == trendingsBooks?.works.count {
                UIBlockingProgressHUD.dismiss()
                topBooksCollectionView.reloadData()
            }
        }
    }
    private var recentImages = [UIImage]() 
    private (set) var searchText: String = ""
    private var trendingsBooks: MyTrendingModel?
    private var typeOfEvent: TypeOfEvent
    
    enum TypeOfEvent {
        case topBooks
        case recentBooks
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
        recentBooks = recentService.recentBooks.reversed()
        recentBooksCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        applyConstraints()
    }
    
    init(typeOfEvent: TypeOfEvent) {
        self.typeOfEvent = typeOfEvent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var topBooksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopBooksCollectionViewCell.self, forCellWithReuseIdentifier: TopBooksCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var recentBooksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecentBooksCollectionViewCell.self, forCellWithReuseIdentifier: RecentBooksCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var topBooksTitle: UILabel = {
        let label = UILabel()
        label.text = "Top Books"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
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

    private func downloadCover(coverId: String) {
        ImageLoader.loadImage(withCoverID: coverId, size: .S) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                if let image = image {
                    self.images.append(image)
                    print(self.images)
                    print(coverId)
                } else {
                    print("Failed to load image")
                }
            }
        }
    }
    
    private func sortByWeekly() {
        UIBlockingProgressHUD.show()
        openLibraryService.fetchTrendingLimit10(sortBy: .weekly, limit: 10) { [weak self] result in
            guard let self else { return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.images = []
                    for i in data.works {
                        ImageLoader.loadImage(withCoverID: "\(i.coverId ?? 0)", size: .M) { image in
                            if let image = image {
                                self.images.append(image)
                                print(self.images.count)
                            } else {
                                print("Failed to file image")
                            }
                        }
                    }
                    self.trendingsBooks = data
                case .failure(let error):
                    print(error.localizedDescription)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    private func sortByMothly() {
        UIBlockingProgressHUD.show()
        openLibraryService.fetchTrendingLimit10(sortBy: .monthly, limit: 20) { [weak self] result in
            guard let self else { return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.images = []
                    for i in data.works {
                        ImageLoader.loadImage(withCoverID: "\(i.coverId ?? 0)", size: .M) { image in
                            if let image = image {
                                self.images.append(image)
                                print(self.images.count)
                            } else {
                                print("Failed to file image")
                            }
                        }
                    }
                    self.trendingsBooks = data
                case .failure(let error):
                    print(error.localizedDescription)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    private func sortByYearly() {
        UIBlockingProgressHUD.show()
        openLibraryService.fetchTrendingLimit10(sortBy: .yearly, limit: 20) { [weak self] result in
            guard let self else { return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.images = []
                    for i in data.works {
                        ImageLoader.loadImage(withCoverID: "\(i.coverId ?? 0)", size: .M) { image in
                            if let image = image {
                                self.images.append(image)
                                print(self.images.count)
                            } else {
                                print("Failed to file image")
                            }
                        }
                    }
                    self.trendingsBooks = data
                case .failure(let error):
                    print(error.localizedDescription)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    private func sortByNow() {
        UIBlockingProgressHUD.show()
        openLibraryService.fetchTrendingLimit10(sortBy: .now, limit: 20) { [weak self] result in
            guard let self else { return}
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.images = []
                    for i in data.works {
                        ImageLoader.loadImage(withCoverID: "\(i.coverId ?? 0)", size: .M) { image in
                            if let image = image {
                                self.images.append(image)
                                print(self.images.count)
                            } else {
                                print("Failed to file image")
                            }
                        }
                    }
                    self.trendingsBooks = data
                case .failure(let error):
                    print(error.localizedDescription)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    
    private func addView() {
        [topBooksTitle, topBooksCollectionView, recentLabel, recentBooksCollectionView, buttonCollection].forEach(view.setupView(_:))
    }
    
    private func applyConstraints() {
        
        if typeOfEvent == .topBooks {
            sortByNow()
            recentLabel.isHidden = true
            recentBooksCollectionView.isHidden = true
            NSLayoutConstraint.activate([
                topBooksTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                topBooksTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 95),
                buttonCollection.leadingAnchor.constraint(equalTo: topBooksTitle.leadingAnchor),
                buttonCollection.topAnchor.constraint(equalTo: topBooksTitle.bottomAnchor, constant: 15),
                buttonCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                buttonCollection.bottomAnchor.constraint(equalTo: topBooksCollectionView.topAnchor,constant: -15),
                topBooksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                topBooksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                topBooksCollectionView.topAnchor.constraint(equalTo: topBooksTitle.bottomAnchor, constant: 65),
                topBooksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            ])
        } else if typeOfEvent == .recentBooks {
            topBooksTitle.isHidden = true
            buttonCollection.isHidden = true
            topBooksCollectionView.isHidden = true
            NSLayoutConstraint.activate([
                recentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                recentLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 95),
                recentBooksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                recentBooksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                recentBooksCollectionView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 20),
                recentBooksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            ])
        }
    }
    
   private func removeSubstringFromWorks(_ input: String) -> String {
        return input.replacingOccurrences(of: "/works/", with: "")
    }
    
}

extension SeeMoreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topBooksCollectionView:
            guard let count = trendingsBooks?.works.count else { return 0}
            return count
        case recentBooksCollectionView:
            return recentBooks.count
        case buttonCollection:
            return sortButtonNames.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case topBooksCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopBooksCollectionViewCell.identifier, for: indexPath) as? TopBooksCollectionViewCell else { return UICollectionViewCell()}
            guard let model = trendingsBooks?.works[indexPath.row] else { return UICollectionViewCell()}
            var coverImage = UIImage()
            ImageLoader.loadImage(withCoverID: "\(trendingsBooks?.works[indexPath.row].coverId ?? 0)", size: .M) { image in
                if let image = image {
                    coverImage = image
                }
            }
            cell.configureCell(title: model.title,
                                author: model.authorNames?[0] ?? "Unknown",
                               genre: "\(model.firstPublishYear ?? 0)",
                               image: coverImage)
            return cell
        case recentBooksCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentBooksCollectionViewCell.identifier, for: indexPath) as? RecentBooksCollectionViewCell else { return UICollectionViewCell()}
            let model = recentBooks[indexPath.row]
            cell.configureCell(title: model.title, author: model.category, image: model.image)
            return cell
        case buttonCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
            let model = sortButtonNames[indexPath.row]
            cell.configure(title: model)
            return cell
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
            return CGSize(width: collectionView.bounds.width / 2.4 + 23, height: collectionView.bounds.height / 2.5 + 10)
        case recentBooksCollectionView:
            return CGSize(width: collectionView.bounds.width / 2.4 + 23, height: collectionView.bounds.height / 2.5 + 10)
        case buttonCollection:
            return CGSize(width: collectionView.bounds.width / 3 - 10, height: collectionView.bounds.height)
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
        case buttonCollection:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ButtonCollectionViewCell else {
            guard let model = trendingsBooks?.works[indexPath.row] else { return }
            let id = removeSubstringFromWorks(model.key)
            let vc = BookDescriptionViewController(bookId: id)
            navigationController?.pushViewController(vc, animated: true)
            print(id)
            return
        }
        
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


