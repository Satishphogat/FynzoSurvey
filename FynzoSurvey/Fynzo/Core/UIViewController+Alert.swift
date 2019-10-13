import Foundation
import UIKit

public extension UIViewController {

    func alert(message: String, title: String = "", oKAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: oKAction)

        alertController.addAction(OKAction)

        present(alertController, animated: true, completion: nil)
    }

    func alertWithTwoAction(message: String, title: String = "", okButtonTitle: String = "", cancelButtonTitle: String = "", OKAction: ((UIAlertAction) -> Void)? = nil, cancelaction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: OKAction)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelaction)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func noInternetConnection() {
        alertWithTwoAction(message: Fynzo.LabelText.noInternetOpenSetting, title: Fynzo.AlertMessages.noInternetConnection, okButtonTitle: Fynzo.ButtonTitle.settings, cancelButtonTitle: Fynzo.ButtonTitle.cancel, OKAction: { (_) in
            guard let urlString = URL(string: UIApplicationOpenSettingsURLString) else {return}
            UIApplication.shared.open(urlString, options: [:], completionHandler: nil)
        })
    }
    
    func customizedAlert(withTitle title: String = "", message mess: String, iconImage image: UIImage = #imageLiteral(resourceName: "ic_logout_alert"), buttonTitles array: [String] = ["OK"], afterDelay delay: Double = 0, completion: ((Int) -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let alert = SCLAlertView()
            for index in 0..<array.count {
                alert.addButton(array[index], action: {
                    alert.hideView()
                    completion?(index)
                })
            }
            alert.showCustom(title, subTitle: mess, icon: image)
        }
    }
}
