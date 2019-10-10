//
//  UIViewController+SideMenu.swift
//  ContactManager
//
//  Created by SK on 31/08/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

extension UIViewController {
    
    func openMenu() {
        let controller = SideMenuViewController.instantiate(fromAppStoryboard: .SideMenu)
        let navigation = UISideMenuNavigationController(rootViewController: controller)
        navigation.leftSide = true
        SideMenuManager.default.menuLeftNavigationController = navigation
        SideMenuManager.default.menuWidth = SwifterSwift.screenWidth - 70
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        present(SideMenuManager.default.menuLeftNavigationController ?? UINavigationController(), animated: true, completion: nil)
    }
}
