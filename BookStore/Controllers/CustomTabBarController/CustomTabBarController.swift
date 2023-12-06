//
//  CustomTabBarController.swift
//  BookStore
//
//  Created by Vanopr on 02.12.2023.
//

import UIKit
import OpenLibraryKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarAppearance()
        generateTabBar()
        
    }

    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: HomeViewController(),
                title: "Home",
                image: UIImage(named: "Home"),
                selectedImage: UIImage(named: "HomeFill")
            ),
            generateVC(
                viewController: CategoriesViewController(),
                title: "Categories",
                image: UIImage(named: "Categories"),
                selectedImage: UIImage(named: "CategoriesFill")
            ),
            generateVC(
                viewController: LikesViewController(),
                title: "Likes",
                image: UIImage(named: "Likes"),
                selectedImage: UIImage(named: "LikesFill")
            ),
            generateVC(
                viewController: AccountViewController(),
                title: "Account",
                image: UIImage(named: "Account"),
                selectedImage: UIImage(named: "AccountFill")
            )
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) -> UIViewController {
        let vc = UINavigationController(rootViewController: viewController)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        return vc
    }
    
    private func setTabBarAppearance() {
        tabBar.layer.masksToBounds = true
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width
        let height = tabBar.bounds.height + 50
        let roundLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: 0,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: 0
        )
        
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        roundLayer.fillColor = UIColor.ghostWhite.cgColor
        tabBar.layer.masksToBounds = false
        let appearance = UITabBarItem.appearance()
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        appearance.setTitleTextAttributes(attributes, for: .normal)
    }
    
}

