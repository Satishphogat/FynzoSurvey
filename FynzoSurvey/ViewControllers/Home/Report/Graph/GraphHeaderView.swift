//
//  RequestDetailHeaderView.swift
//  HouzzFix Technician
//
//  Created by Mohd Maruf on 29/01/19.
//  Copyright © 2019 SK. All rights reserved.
//

import UIKit
import ABGaugeViewKit

class GraphHeaderView: UIView {
    
    @IBOutlet weak var graphView: SimplePieChartView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var speedometerContainerView: UIView!
    @IBOutlet weak var speedometerView: ABGaugeView!
    @IBOutlet weak var netPromoterTitleLabel: UILabel!
    @IBOutlet weak var netPromoterValueLabel: UILabel!

    class func instanceFromNib() -> GraphHeaderView {
        return UINib(nibName:  "GraphHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GraphHeaderView
    }
}
