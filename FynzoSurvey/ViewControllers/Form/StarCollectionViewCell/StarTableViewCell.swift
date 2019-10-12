//
//  StarTableViewCell.swift
//  FynzoSurvey
//
//  Created by satish phogat on 12/10/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import Cosmos

class StarTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
}
