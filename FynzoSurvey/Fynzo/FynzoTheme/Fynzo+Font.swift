import Foundation
import UIKit

typealias FynzoFont = UIFont

extension UIFont {
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: Fynzo.Font.regular, size: size)!
    }
    
    static func extraLight(size: CGFloat) -> UIFont {
        return UIFont(name: Fynzo.Font.extraLight, size: size)!
    }
    
    static func thin(size: CGFloat) -> UIFont {
        return UIFont(name: Fynzo.Font.thin, size: size)!
    }
    
    static func light(size: CGFloat) -> UIFont {
        return UIFont(name: Fynzo.Font.light, size: size)!
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: Fynzo.Font.medium, size: size)!
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: Fynzo.Font.bold, size: size)!
    }
    
    static func semiBold(size: CGFloat) -> UIFont {
        return UIFont(name: Fynzo.Font.semiBold, size: size)!
    }
}
