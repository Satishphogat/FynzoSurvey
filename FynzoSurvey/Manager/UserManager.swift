//

import Foundation
import UIKit

class UserManager: UIViewController {
    
    static let shared = UserManager()
    var userInfo = UserInfo()
    
    func moveToLogin() {
        moveToRootViewController()
    }
    
    func moveToRootViewController() {
        let loginController = LoginViewController.instantiate(fromAppStoryboard: .Authentication)
        let navigationController = UINavigationController(rootViewController: loginController)
        navigationController.navigationBar.barTintColor = AppDelegate.shared.appThemeColor
        AppDelegate.shared.window?.rootViewController = navigationController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    func moveToHomeViewController() {
        let controller = HomeViewController.instantiate(fromAppStoryboard: .Home)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.barTintColor = AppDelegate.shared.appThemeColor
        AppDelegate.shared.window?.rootViewController = navigationController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
}
