//
//  UIViewController+NavigationBar.swift
//  Lussot
//
//  Created by SK on 14/09/18.
//  Copyright © 2018 Mohd Maruf. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func configureNavigationBar(withTitle title: String = "", leftBarButtonTitle leftTitle: String = "", leftBarImage leftImage: UIImage = UIImage(), rightBarImage rightImage: UIImage = UIImage(), leftSelector leftAction: Selector? = nil, rightSelector rightAction: Selector? = nil, titleColor color: UIColor = .white, shouldShowBackground showBackground: Bool = true, rightBarButtonTitle: String = "") {
        navigationController?.navigationBar.isHidden = false
        if let selector = leftAction {
            let leftButton = leftTitle == "" ? CustomNavigationItem.backButton(self, image: leftImage, action: selector) : CustomNavigationItem.leftBarButtonWithTitle(self, buttonTitle: leftTitle, action: selector)
            let titleButton = CustomNavigationItem.leftBarButtonWithTitle(self, buttonTitle: title, action: #selector(emptyFunc))
            navigationItem.leftBarButtonItems = [leftButton, titleButton]
        } else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
        }
        if let selector = rightAction {
            navigationItem.rightBarButtonItem = rightBarButtonTitle == "" ? CustomNavigationItem.rightBarButton(self, buttonImage: rightImage, action: selector) : CustomNavigationItem.rightBarButtonWithTitle(self, buttonTitle: rightBarButtonTitle, action: selector)
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        if leftAction == nil {
            navigationItem.title = title
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = AppDelegate.shared.appThemeColor
        navigationController?.navigationBar.backgroundColor = AppDelegate.shared.appThemeColor
        navigationController?.navigationBar.isTranslucent = false
        if !showBackground {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.view.backgroundColor = .clear
            navigationController?.navigationBar.backgroundColor = .clear
        }
    }
    
    @objc func emptyFunc() {
        
    }
}

class CustomNavigationItem {
    
    typealias Action = () -> Void
    
    class func backButton(_ controller: Any, image: UIImage, action: Selector) -> UIBarButtonItem {
        return NavigationBar.leftBarButton(controller, buttonImage: image, action: action)
    }
    
    class func rightBarButton(_ controller: Any, buttonImage: UIImage, action: Selector) -> UIBarButtonItem {
        return NavigationBar.rightBarButton(controller, buttonImage: buttonImage, action: action)
    }
    
    class func rightBarButtonWithTitle(_ controller: Any, buttonTitle: String, action: Selector) -> UIBarButtonItem {
        return NavigationBar.rightBarButtonWithTitle(controller, buttonTitle: buttonTitle, action: action)
    }
    
    class func leftBarButtonWithTitle(_ controller: Any, buttonTitle: String, action: Selector) -> UIBarButtonItem {
        return NavigationBar.leftBarButtonWithTitle(controller, buttonTitle: buttonTitle, action: action)
    }
}
