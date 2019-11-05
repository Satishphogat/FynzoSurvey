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
            urlLabel.text = shareUrl
        }
    }
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var shareUrl = ""
    
    @IBAction func copyButtonAction() {
        UIPasteboard.general.string = shareUrl
    }
    
    @IBAction func shareButtonAction() {
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
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
