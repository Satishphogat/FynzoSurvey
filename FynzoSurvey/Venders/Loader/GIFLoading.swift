//
//  PUGifLoading.swift
//  Indulge
//
//  Created by Krishan Kumar on 23/08/19.
//  Copyright © 2019 Keshav Tiwari. All rights reserved.
//

import Foundation
import UIKit

public class GIFLoading
{
    static let shared = GIFLoading()
    public var recentOverlay : UIView?
    public var recentOverlayTarget : UIView?
    public var recentLoadingText: String?
    public init() {}
    public func Color_RGBA(_ R: Int,_ G: Int,_ B: Int,_ A: Int) -> UIColor
    {
        return UIColor(red: CGFloat(R)/255.0, green: CGFloat(G)/255.0, blue: CGFloat(B)/255.0, alpha :CGFloat(A))
    }
    public func FontWithSize(_ fname: String,_ fsize: Int) -> UIFont
    {
        return UIFont(name: fname, size: CGFloat(fsize))!
    }
    
    public func hide() {
        if recentOverlay != nil
        {
            recentOverlay?.removeFromSuperview()
            recentOverlay =  nil
            recentLoadingText = nil
            recentOverlayTarget = nil
        }
    }
   
    public func showWithActivityIndicator(_ loadingText:String?, activitycolor: UIColor, labelfontcolor:UIColor , labelfontsize: Int,activityStyle: UIActivityIndicatorView.Style) {
        hide()
        let overlayvw = UIApplication.shared.keyWindow!
        let overlay = UIView(frame: overlayvw.frame)
        overlay.center = overlayvw.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        overlayvw.addSubview(overlay)
        overlayvw.bringSubview(toFront: overlay)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: activityStyle)
        indicator.color = activitycolor
        indicator.center = overlay.center
        indicator.startAnimating()
        overlay.addSubview(indicator)
        let label = UILabel()
        if let textString = loadingText
        {
            label.text = textString
            label.textColor = labelfontcolor
            label.font = FontWithSize("Verdana", labelfontsize)
            label.sizeToFit()
            label.center = CGPoint(x: indicator.center.x, y: indicator.center.y + 30)
            overlay.addSubview(label)
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.7
        UIView.commitAnimations()
        recentOverlay = overlay
        recentOverlayTarget = overlayvw
        recentLoadingText = loadingText
    }
}
