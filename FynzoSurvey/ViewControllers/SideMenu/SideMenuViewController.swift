//
//  SideMenuViewController.swift
//  ContactManager
//
//  Created by SK on 31/08/18.
//  Copyright © 2018 SK. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = AppUserDefaults.value(forKey: .fullName, fallBackValue: false) as? String ?? ""
        }
    }
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.text = AppUserDefaults.value(forKey: .email, fallBackValue: false) as? String ?? ""
        }
    }
    @IBOutlet weak var legalTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: SideMenuTableViewCell.self)
        }
    }
    @IBOutlet weak var versionNumberLabel: UILabel!
    
    var notificationCount = 0
    static var isFromSideMenu = false
    var userInfo = UserInfo()
    var selectedMenuIndex = 0
    private let titleArray = [Fynzo.LabelText.home, Fynzo.LabelText.setting, Fynzo.LabelText.help, Fynzo.LabelText.contactUs, Fynzo.LabelText.chatWithUs, Fynzo.LabelText.logout]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        configFreshChat()
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        
    }
    
    func logoutButtonAction() {
        customizedAlert(message: Fynzo.AlertMessages.logoutMessage, buttonTitles: [Fynzo.ButtonTitle.cancel.uppercased(), Fynzo.ButtonTitle.ok]) { (index) in
            if index == 1 { // OK
                self.logout()
            }
        }
    }
    
    private func logout() {
        dismiss(animated: false, completion: nil)
        AppUserDefaults.removeAllValues()
        UserManager.shared.moveToLogin()
    }
    
    private func configFreshChat() {
        let user = FreshchatUser.sharedInstance();
        user?.firstName = AppUserDefaults.value(forKey: .fullName, fallBackValue: "") as? String ?? ""
        user?.lastName = ""
        user?.email = AppUserDefaults.value(forKey: .email, fallBackValue: "") as? String ?? ""
        user?.phoneCountryCode = "+91"
        user?.phoneNumber = AppUserDefaults.value(forKey: .phone, fallBackValue: "") as? String ?? ""
        Freshchat.sharedInstance().setUser(user)
        
        
        Freshchat.sharedInstance().unreadCount { (count:Int) -> Void in
            self.notificationCount = count
            self.tableView.reloadData()
        }
    }
}

extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: SideMenuTableViewCell.self)
        
        cell.icomImageView.image = UIImage(named: titleArray[indexPath.row])!
        if indexPath.row != 4 {
            cell.titleLabel.text = titleArray[indexPath.row]
        } else {
            cell.titleLabel.text = "\(titleArray[indexPath.row]) ( \(notificationCount) )"
        }
            
        return cell
    }
}

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMenuIndex = indexPath.row
        tableView.reloadData()
        if indexPath.row == 0 {
            let controller = HomeViewController.instantiate(fromAppStoryboard: .Home)
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 1 {
            let controller = SettingViewController.instantiate(fromAppStoryboard: .SideMenu)
            if let res = AppUserDefaults.value(forKey: .settings, fallBackValue: "") as? [[String]] {
                controller.dataArray = res
            }
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == titleArray.count - 1 {
            logoutButtonAction()
        } else if indexPath.row == 2 {
            let controller = HelpViewController.instantiate(fromAppStoryboard: .SideMenu)
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 3 {
            let controller = ContactUsViewController.instantiate(fromAppStoryboard: .SideMenu)
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 4 {
            DispatchQueue.main.async {
                Freshchat.sharedInstance().showConversations(self)
            }
        }
    }
}
