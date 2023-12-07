//
//  OnboardingView.swift
//  BookStore
//
//  Created by Юрий on 05.12.2023.
//

import UIKit

class OnboardingView: UIView {
    
    //MARK: - UI Elements
    
    private let onboardingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.shadowColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let onboardingImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "Group")
        return image
    }()

    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(onboardingImage)
        addSubview(logoImage)
        addSubview(onboardingTextLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    
    func setOnboardingLabelText(text: String) {
        onboardingTextLabel.text = text
    }
    
    func setOnboardingImage(image: UIImage) {
        onboardingImage.image = image
    }
    
    //MARK: - Methods
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            onboardingImage.topAnchor.constraint(equalTo: topAnchor),
            onboardingImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            onboardingImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            onboardingImage.heightAnchor.constraint(equalToConstant: 400),
            
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            onboardingTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            onboardingTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            onboardingTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 145)
        
        ])
    }
    
}
