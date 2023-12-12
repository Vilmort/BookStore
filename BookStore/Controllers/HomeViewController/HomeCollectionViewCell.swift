import UIKit
import Kingfisher
import OpenLibraryKit

final class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    var cellModel: TrendingItem?
    
    
    private lazy var collectionView: UIView = {
       let collectionView = UIView()
        collectionView.layer.cornerRadius = 8
        collectionView.backgroundColor = .lightGray
        return collectionView
    }()
    
    private lazy var coverView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockImage")
        return imageView
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Classics"
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private lazy var nameOfBookLabel: UILabel = {
        let label = UILabel()
        label.text = "The Picture of Dorian Gray"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var nameOfAuthorLabel: UILabel = {
        let label = UILabel()
        label.text = "Oscar Wilde"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.backgroundColor = .black
        return view
    }()
    
    private func addSubview() {
        contentView.addSubview(collectionView)
        collectionView.addSubview(coverView)
        collectionView.addSubview(blackView)
        blackView.addSubview(genreLabel)
        blackView.addSubview(nameOfBookLabel)
        blackView.addSubview(nameOfAuthorLabel)
    }
    
    private func addView() {
        [collectionView, coverView, blackView, genreLabel, nameOfBookLabel, nameOfAuthorLabel ].forEach(setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blackView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            blackView.topAnchor.constraint(equalTo: coverView.bottomAnchor),
            blackView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            coverView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 11),
            coverView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: blackView.leadingAnchor, constant: 16),
            genreLabel.topAnchor.constraint(equalTo: coverView.bottomAnchor, constant: 6),
            nameOfBookLabel.leadingAnchor.constraint(equalTo: genreLabel.leadingAnchor),
            nameOfBookLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor),
            nameOfBookLabel.trailingAnchor.constraint(equalTo: blackView.trailingAnchor, constant: -20),
            nameOfAuthorLabel.leadingAnchor.constraint(equalTo: genreLabel.leadingAnchor),
            nameOfAuthorLabel.topAnchor.constraint(equalTo: nameOfBookLabel.bottomAnchor, constant: 5),
            nameOfAuthorLabel.trailingAnchor.constraint(equalTo: blackView.trailingAnchor, constant: -16)
        ])
    }
    
    func configureCell(
        title: String,
        author: String,
        genre: String,
        image: UIImage
    ) {
        nameOfBookLabel.text = title
        nameOfAuthorLabel.text = author
        genreLabel.text = genre
        coverView.image = image
    }
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        applyConstraints()
        addSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
