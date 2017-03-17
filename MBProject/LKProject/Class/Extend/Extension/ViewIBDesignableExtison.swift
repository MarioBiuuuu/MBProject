//
//  MyView.swift
//  SwiftExtison
//
//  Created by ZhangXiaofei on 17/2/28.
//  Copyright © 2017年 Yuri. All rights reserved.
//

import UIKit
//@IBDesignable告诉编译器，此类可以被nib识别使用
@IBDesignable class ViewIBDesignableExtison: UIView {
    //@IBInspectable告诉编译器，此属性可以被nib使用
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize? {
        didSet {
            layer.shadowOffset = shadowOffset!
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
}
