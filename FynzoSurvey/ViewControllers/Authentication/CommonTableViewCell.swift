//
//  CommonTableViewCell.swift
//  Mohd Maruf
//
//  Created by Mohd Maruf on 29/11/18.
//  Copyright © 2018 Mohd Maruf. All rights reserved.
//

import UIKit

class CommonTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var passwordShowHide: UIButton!
    @IBOutlet weak var changePassword: UIButton! {
        didSet {
            changePassword.setAttributedTitle(underline("Change Password", font: UIFont.systemFont(ofSize: 16), color: AppDelegate.shared.buttonColor), for: .normal)
        }
    }
    @IBOutlet weak var textFieldLeading: NSLayoutConstraint!
}
