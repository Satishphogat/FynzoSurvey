//
//  WebKitViewController.swift
//  FynzoSurvey
//
//  Created by Mohammad Maruf  on 02/12/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            if let url = URL(string: AppConfiguration.createSurvey) {
                webView.load(URLRequest(url: url))
                webView.navigationDelegate = self
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LoaderView.showIndicator(view)
        configureNavigationBar(withTitle: "Create Survey", leftBarImage: Fynzo.Image.back, leftSelector: #selector(leftButtonAction))
    }
    
    @objc private func leftButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension WebKitViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}
