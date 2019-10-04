//
//  KPItemView.swift
//  KPActionSheet
//
//  Created by Khuong Pham on 2/25/17.
//  Copyright © 2017 fantageek. All rights reserved.
//

import UIKit

public class KPItemView: UIView {
    
    public typealias TapHandler = (() -> ())
    
    @IBOutlet var controlLabel: UILabel!
    @IBOutlet private var view: UIView!
    
    private var touchingDown: Bool = false {
        didSet {
            view.backgroundColor = touchingDown ?
                UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) :
                UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    public var item: KPItem! {
        didSet {
            controlLabel.text = item.title
            switch item.type {
            case .Normal:
                controlLabel.textColor = AppDelegate.shared.appThemeColor
            case .Delete:
                controlLabel.textColor = #colorLiteral(red: 0.9882352941, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            default:
                controlLabel.textColor = AppDelegate.shared.appDarkGray
            }
        }
    }
    
    public var tapHandler: TapHandler?
    
    public init(frame: CGRect, item: KPItem, onTap tapHandler: TapHandler?) {
        super.init(frame: frame)
        
        self.tapHandler = tapHandler
        initSubViews(item: item)
    }
    
    required public init?(coder aDecoder: NSCoder, item: KPItem, onTap tapHandler: TapHandler?) {
        super.init(coder: aDecoder)
        
        self.tapHandler = tapHandler
        initSubViews(item: item)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews(item: KPItem) {
        let nib = UINib(nibName: "KPItemView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        if item.type == .Cancel {
            let topBorderView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.5))
            topBorderView.backgroundColor = AppDelegate.shared.appThemeColor
            view.addSubview(topBorderView)
        }
        
        view.frame = bounds
        addSubview(view)
        self.item = item
    }
    
    private func isTouchesInsideView(touches: Set<UITouch>) -> Bool {
        if let touch = touches.first {
            let touchPoint = touch.location(in: view)
            return view.frame.contains(touchPoint)
        }
        return false
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingDown = true
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingDown = isTouchesInsideView(touches: touches)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingDown = false
        if isTouchesInsideView(touches: touches) && item.type != .Title {
            self.tapHandler?()
        }
    }
}
