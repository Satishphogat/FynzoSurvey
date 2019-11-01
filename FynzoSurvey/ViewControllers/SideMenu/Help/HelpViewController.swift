//
//  HelpViewController.swift
//  FynzoSurvey
//
//  Created by satish phogat on 26/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: HelpTableViewCell.self)
        }
    }
    
    var titleArray = [(title: "How to create a survey?", subTitle: "There are two ways to create a survey. First one is, you can import the existing template from the app.Second method is helpful when you want to create survey from scratch.For that you will have to log into web admin panel at https://www.fynzo.com/survey.After login click on 'Surveys-> Create New Survey' in left menu panel."),
    (title: "How to collect responses?", subTitle: "To collect the feedback from App, click the start button along the feedback form name in the feedback form list. It will give you options about how you want to open the feedback form."),
    (title: "How to send responses to server?", subTitle: "If your device is connected to the internet, survey will be sent to the server automatically. If it is not connected to the internet, it will be saved in the app and can be synced with the server any time from upload button given on bottom right of the App dashboard."),
    (title: "How to see reports and download data?", subTitle: "You can see and download responses collected by Fynzo app, by clicking on 'Response' in web admin panel. You can see the responses in the app as well. To see the responses for a particular survey, click on 'Start -> Response Report' in app."),
    (title: "How do I delete my account?", subTitle: "You can simply go to settings in webpanel and delete your account. All the data collected by that particular account will be deleted right after."),
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Help", leftBarImage: #imageLiteral(resourceName: "ic_menu"), leftSelector: #selector(leftButtonAction))
    }
    
    @objc func leftButtonAction() {
        openMenu()
    }

}


extension HelpViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HelpTableViewCell.self)
        cell.titleLabel.text = titleArray[indexPath.row].title
        cell.subtitleLabel.text = titleArray[indexPath.row].subTitle
        
        return cell
    }
}
