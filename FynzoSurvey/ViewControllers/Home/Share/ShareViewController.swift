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
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func copyButtonAction() {
        
    }
    
    @IBAction func shareButtonAction() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Share", leftBarImage: #imageLiteral(resourceName: "leftArrowWhite"), leftSelector: #selector(leftButtonAction))
        
    }
    
    @objc func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
