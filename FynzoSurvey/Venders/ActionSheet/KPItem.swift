//
//  KPMenuViewItem.swift
//  KPActionSheet
//
//  Created by Khuong Pham on 2/25/17.
//  Copyright © 2017 fantageek. All rights reserved.
//

import Foundation

public struct KPItem {
    
    public enum ItemType {
        case Normal
        case Cancel
        case Title
        case Delete
    }
    
    public typealias TapHandler = (() -> ())
    
    public var title: String? = nil
    public var titleColor: String? = nil
    public var type: ItemType = .Normal
    public var tapHandler: TapHandler?
    
    public init(title: String?, titleColor: String? = "", type: ItemType = .Normal, onTap tapHandler: TapHandler?) {
        self.title = title
        self.titleColor = titleColor
        self.tapHandler = tapHandler
        self.type = type
    }
    
    public init(title: String?, titleColor: String? = "", type: ItemType) {
        self.title = title
        self.type = type
        self.titleColor = titleColor
    }
}
