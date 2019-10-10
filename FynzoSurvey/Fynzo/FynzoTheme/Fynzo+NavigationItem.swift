import Foundation
import UIKit

class FynzoNavigationItem {
    
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
