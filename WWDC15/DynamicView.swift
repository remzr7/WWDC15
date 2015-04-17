//
//  DyanmicView.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/17/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit
import QuartzCore

class DynamicView: UIView, DynamicDelegate {
    
    @IBInspectable var frequency: CGFloat = 3;
    
    required init(coder aDecoder:NSCoder){
        
        super.init(coder: aDecoder)
        
    }
    
    override func init(frame:CGRect){
        super.init(frame)
        
        setup()
    }
    
    
    func setup()
    {
        layer.masksToBounds = false
        layer.addSublayer(maskLayer)
        (layer as! DynamicLayer).dynamicDelegate = self
    }
    

}

extension DynamicView: DynamicDelegate
{
    func positionChanged(){
        
        
    }
}


private protocol DynamicDelegate
{
    func positionChanged()
}

private class DynamicLayer:CAShapeLayer
{
    var dynamicDelegate: DynamicDelegate?
    
    override var position: CGPoint{
        didSet{
            DynamicDelegate.positionChanged()
        }
    }
}