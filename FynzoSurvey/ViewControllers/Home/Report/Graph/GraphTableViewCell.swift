//
//  GraphTableViewCell.swift
//  FynzoSurvey
//
//  Created by Mohammad Maruf  on 08/11/19.
//  Copyright © 2019 Mohd Maruf. All rights reserved.
//

import UIKit
import Cosmos

class GraphTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var sideIndecatorLabel: UILabel!
}
