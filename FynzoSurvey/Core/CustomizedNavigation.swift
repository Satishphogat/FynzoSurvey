import UIKit
import Foundation

open class NavigationBar {
    
    typealias Action = () -> Void
    
    class func leftBarButton(_ controller: Any, buttonImage: UIImage, action: Selector) -> UIBarButtonItem {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        backButton.setImage(buttonImage, for: .normal)
        backButton.setImage(buttonImage, for: .selected)
        backButton.setImage(buttonImage, for: .highlighted)
        backButton.contentHorizontalAlignment = .left
        backButton.contentMode = .center
        backButton.addTarget(controller, action: action, for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        
        return backBarButtonItem
    }
    
    class func rightBarButton(_ controller: Any, buttonImage: UIImage, action: Selector) -> UIBarButtonItem {
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 22.0, height: 30.0)
        barButton.setImage(buttonImage, for: .normal)
        barButton.setImage(buttonImage, for: .selected)
        barButton.setImage(buttonImage, for: .highlighted)
        barButton.contentHorizontalAlignment = .right
        barButton.addTarget(controller, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: barButton)
        
        return barButtonItem
    }
    
    class func rightBarButtonWithTitle(_ controller: Any, buttonTitle: String, action: Selector) -> UIBarButtonItem {
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40.0, height: 30.0)
        barButton.setTitle(buttonTitle, for: .normal)
        barButton.contentHorizontalAlignment = .right
        barButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        barButton.setTitleColor(UIColor.white, for: .normal)
        barButton.addTarget(controller, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: barButton)
        
        return barButtonItem
    }
    
    class func leftBarButtonWithTitle(_ controller: Any, buttonTitle: String, action: Selector) -> UIBarButtonItem {
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40.0, height: 30.0)
        barButton.setTitle(buttonTitle, for: .normal)
        barButton.contentHorizontalAlignment = .left
        barButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        barButton.setTitleColor(UIColor.white, for: .normal)
        barButton.addTarget(controller, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: barButton)
        
        return barButtonItem
    }
}
