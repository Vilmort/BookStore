//
//  CustomPageControl.swift
//  BookStore
//
//  Created by Юрий on 05.12.2023.
//

import UIKit

class CustomPageControl: UIPageControl {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Устанавливаем размеры фона
        let backgroundWidth: CGFloat = CGFloat(numberOfPages) * self.pageIndicatorSpacing
        let backgroundHeight: CGFloat = 20
        let backgroundX: CGFloat = (self.bounds.width - backgroundWidth) / 2
        let backgroundY: CGFloat = (self.bounds.height - backgroundHeight) / 2
        let backgroundFrame = CGRect(x: backgroundX, y: backgroundY, width: backgroundWidth, height: backgroundHeight)
        
        // Создаем и настраиваем фоновое представление
        let backgroundView = UIView(frame: backgroundFrame)
        backgroundView.backgroundColor = .systemGray5
        self.pageIndicatorTintColor = .white
        self.currentPageIndicatorTintColor = .black
        backgroundView.layer.cornerRadius = backgroundHeight / 2
        
        
        // Добавляем фоновое представление на задний план
        self.insertSubview(backgroundView, at: 0)
    }
    
    private let pageIndicatorSpacing: CGFloat = 20

}
