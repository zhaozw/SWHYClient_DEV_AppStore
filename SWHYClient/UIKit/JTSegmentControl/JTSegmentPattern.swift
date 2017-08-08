//
//  JTSegmentPattern.swift
//  JTSegementControlDemo
//
//  Created by xia on 16/11/12.
//  Copyright © 2016年 JT. All rights reserved.
//

import UIKit

struct JTSegmentPattern {
    
    static let itemTextColor = UIColor.grayColor()
    static let itemSelectedTextColor = UIColor(red: 252.0, green: 107.0, blue: 1.0, alpha: 0.3)
    
    static let itemBackgroundColor = UIColor(red: 255.0, green: 250.0, blue: 250.0, alpha: 1.0)
    static let itemSelectedBackgroundColor = UIColor(red: 252.0, green: 107.0, blue: 1.0, alpha: 0.1)
    
    static let itemBorder : CGFloat = 20.0
    //MARK - Text font
    static let textFont = UIFont.systemFontOfSize(16.0)
    static let selectedTextFont = UIFont.boldSystemFontOfSize(19.0)
    
    //MARK - slider
    static let sliderColor = UIColor.orangeColor()
    static let sliderHeight : CGFloat = 5.0
    
    //MARK - bridge
    static let bridgeColor = UIColor.redColor()
    static let bridgeWidth : CGFloat = 7.0
    
    //MARK - inline func
    @inline(__always) static func color(red:Float, green:Float, blue:Float, alpha:Float) -> UIColor {
        return UIColor(colorLiteralRed: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}