//
//  MagicTransition.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/26/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit

class MagicTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animatedView:UIView!
    var startFrame:CGRect!
    
    override init() {
        super.init()
        
    }
    
     init(animatedView view:UIView)
    {
        animatedView = view
        startFrame = CGRect()
        
        super.init()
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        startFrame = animatedView.frame
        
        var animatedViewForTransition:UIView
        
        animatedViewForTransition = UIView(frame: startFrame)
        transitionContext.containerView().addSubview(animatedViewForTransition)
        
        animatedViewForTransition.clipsToBounds = true
        animatedViewForTransition.layer.cornerRadius = CGRectGetHeight(animatedViewForTransition.frame)/2
        
        
        var size = CGRectGetHeight(transitionContext.containerView().frame) * 1.2
        var scaleFactor = size / CGRectGetWidth(animatedViewForTransition.frame)
        var finalTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        
        var presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        presentedController!.view.frame = transitionContext.containerView().bounds
        presentedController!.view.layer.opacity = 0
        transitionContext.containerView().addSubview(presentedController!.view)
        
        
        UIView.transitionWithView(animatedViewForTransition,
            duration: (self.transitionDuration(transitionContext) * 0.7),
            options: nil,
            animations: { () -> Void in
                animatedViewForTransition.transform = finalTransform
                animatedViewForTransition.center = transitionContext.containerView().center
                animatedViewForTransition.backgroundColor = presentedController!.view.backgroundColor
        },
            completion: nil)

        UIView.animateWithDuration(self.transitionDuration(transitionContext) * 0.42,
            delay: self.transitionDuration(transitionContext) * 0.58,
            options: nil, animations: { () -> Void in
                presentedController!.view.layer.opacity = 1
        }) { (finished) -> Void in
            animatedViewForTransition.removeFromSuperview()
            transitionContext.completeTransition(!(transitionContext.transitionWasCancelled()))
        }
    
        
        }
    

}
