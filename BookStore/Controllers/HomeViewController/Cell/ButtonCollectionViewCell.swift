import UIKit

protocol ButtonCollectionViewCellDelegate: AnyObject {
    
}

final class ButtonCollectionViewCell: UICollectionViewCell {
    static let identifier = "ButtonCollectionViewCell"
    
    public weak var delegate: ButtonCollectionViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deselectedCell()
    }
    
    private lazy var collectionView: UIView = {
           let collectionView = UIView()
            collectionView.layer.cornerRadius = 6
        collectionView.backgroundColor = .white
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            return collectionView
        }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("This Week", for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.tintColor = .black
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 8)
        configuration.buttonSize = .medium
        button.configuration = configuration
        button.addTarget(self, action: #selector(method), for: .touchUpInside)
        return button
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "This Week"
        label.textColor = .black
        
        return label
    }()
    
    
    private func addSubview() {
        contentView.addSubview(collectionView)
        collectionView.addSubview(label)
    }
    
    private func addView() {
        [collectionView, label].forEach(setupView(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            label.topAnchor.constraint(equalTo: collectionView.topAnchor),
            label.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
    
    func selectedCell() {
        collectionView.backgroundColor = .black
        collectionView.layer.borderWidth = 0.0
        collectionView.layer.cornerRadius = 6
        label.textColor = .white
    }

    func deselectedCell() {
        collectionView.layer.borderWidth = 1
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 6
        label.textColor = .black
    }
    
    func configure(title: String) {
        label.text = title
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
