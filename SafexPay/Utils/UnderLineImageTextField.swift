//
//  UnderLineImageTextField.swift
//  SafexPay
//
//  Created by Sandeep on 8/7/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

@IBDesignable
class UnderLineImageTextField: UITextField {
    override func draw(_ rect: CGRect) {
        
        let borderLayer = CALayer()
        let widthOfBorder = getBorderWidht()
        borderLayer.frame = CGRect(x: -15, y: self.frame.size.height - widthOfBorder, width: self.frame.size.width+20, height: self.frame.size.height)
        borderLayer.borderWidth = widthOfBorder
        borderLayer.borderColor = getBottomLineColor()
        self.layer.addSublayer(borderLayer)
        self.layer.masksToBounds = true
        
    }
    
    
    
    //MARK : set the image LeftSide
    @IBInspectable var LeftSideImage:UIImage? {
        didSet{
            
            let leftAddView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
            let leftimageView = UIImageView.init(frame: CGRect(x: self.frame.size.height/4, y: self.frame.size.height/4, width: self.frame.size.height/2, height: self.frame.size.height/2))//Create a imageView for left side.
            leftimageView.image = LeftSideImage
            leftAddView.addSubview(leftimageView)
            self.leftView = leftAddView
            self.leftViewMode = UITextField.ViewMode.always
        }
        
    }
    
    //MARK : set the image RightSide
    @IBInspectable var RightSideImage:UIImage? {
        didSet{
            
            let rightAddView = UIView.init(frame: CGRect(x: 0, y: 0, width: 25, height: self.frame.size.height-10))
            let rightimageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))//Create a imageView for right side.
            rightimageView.image = RightSideImage
            rightAddView.addSubview(rightimageView)
            self.rightView = rightAddView
            self.rightViewMode = UITextField.ViewMode.always
        }
        
    }
    @IBInspectable var bottomLineColor: UIColor = UIColor.black {
        didSet {
            
        }
    }
    
    
    func getBottomLineColor() -> CGColor {
        return bottomLineColor.cgColor;
        
    }
    @IBInspectable var cusborderWidth:CGFloat = 1.0
        {
        didSet{
            
        }
    }
    
    func getBorderWidht() -> CGFloat {
        return cusborderWidth;
        
    }
}
