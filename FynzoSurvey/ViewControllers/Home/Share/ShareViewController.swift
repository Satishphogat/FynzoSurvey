//
//  ShareViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel! {
        didSet {
            urlLabel.text = AppConfiguration.appUrl + "u/" + form.uniqueKey
        }
    }
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    var form = Form()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrCodeImageView.image = generateQRCode(from: AppConfiguration.appUrl + "u/" + form.uniqueKey)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    @IBAction func copyButtonAction() {
        UIPasteboard.general.string = AppConfiguration.appUrl + "u/" + form.uniqueKey
    }
    
    @IBAction func shareButtonAction() {
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [AppConfiguration.appUrl + "u/" + form.uniqueKey], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView=self.view
        present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Share", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
