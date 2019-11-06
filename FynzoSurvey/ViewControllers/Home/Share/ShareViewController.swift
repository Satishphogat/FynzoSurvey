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
