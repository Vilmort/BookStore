//
//  WelcomeViewController.swift
//  BookStore
//
//  Created by Юрий on 03.12.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private var slides = [OnboardingView]()
    
    //MARK: - UI Elements
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        var customPageControl = CustomPageControl()
        customPageControl.translatesAutoresizingMaskIntoConstraints = false
        customPageControl.numberOfPages = 3
        return customPageControl
    }()
    
    private let nextButton: UIButton = {
        let nextButton = UIButton(type: .system)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.backgroundColor = .black
        nextButton.tintColor = .lightGray
        nextButton.layer.cornerRadius = 10
        //nextButton.addTarget(self, action: #selector(nextSlide), for: .touchUpInside)
        return nextButton
    }()
    
    private let skipButton: UIButton = {
        let skipButton = UIButton(type: .system)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        return skipButton
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .lightGray
        button.layer.cornerRadius = 10
        //button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setDelegates()
        setConstraints()
        
        slides = createSlides()
        setupSlidesScrollView(slides: slides)
        
    }
    
    //MARK: - Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        view.addSubview(startButton)
    }
    
    private func setDelegates() {
        scrollView.delegate = self
    }
    
    private func createSlides() -> [OnboardingView] {
        let firstOnboardingView = OnboardingView()
        firstOnboardingView.setOnboardingLabelText(text: "Read more and stress less with our online book shopping app. Shop from anywhere you are and discover titles that you love. Happy reading!")
        firstOnboardingView.setOnboardingImage(image: #imageLiteral(resourceName: "First"))
        
        let secondOnboardingView = OnboardingView()
        secondOnboardingView.setOnboardingLabelText(text: "Read everywhere you go!")
        secondOnboardingView.setOnboardingImage(image: #imageLiteral(resourceName: "Second"))
        
        let thirdOnboardingView = OnboardingView()
        thirdOnboardingView.setOnboardingLabelText(text: "Choose a genre you like or read something new every day")
        thirdOnboardingView.setOnboardingImage(image: #imageLiteral(resourceName: "Third"))
        
        return [firstOnboardingView, secondOnboardingView, thirdOnboardingView]
    }
    //MARK: - Actions
    
    @objc private func nextSlide() {
        
    }
    
    private func setupSlidesScrollView(slides: [OnboardingView]) {
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count),
                                        height: view.frame.height)
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i),
                                     y: 0,
                                     width: view.frame.width,
                                     height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
}

// MARK: - UIScrollViewDelegate

extension WelcomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffsetX = targetContentOffset.pointee.x
        let currentPageIndex = Int(targetOffsetX / view.frame.width)
        let lastSlideIndex = slides.count - 1
        
        pageControl.currentPage = currentPageIndex
        
        if currentPageIndex == lastSlideIndex {
            nextButton.isHidden = true
            skipButton.isHidden = true
            startButton.isHidden = false
        }
        else {
            nextButton.isHidden = false
            skipButton.isHidden = false
            startButton.isHidden = true
        }
    }
}

// MARK: - Set Constraints

extension WelcomeViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 25),
            
            nextButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -15),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 56),
            
            startButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -15),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startButton.heightAnchor.constraint(equalToConstant: 56),
            
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            
            
            
        ])
    }
}

