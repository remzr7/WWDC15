//
//  RZMagicLayout.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/23/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit
import Foundation

let kScrollResistanceFactorDefault = 600

let kLength = 0.3
let kDamping = 0.5
let kFrequence = 1.3
let kResistence = 1000

class RZMagicLayout: UICollectionViewFlowLayout
{
    var scrollResistanceFactor:CGFloat!
    var dynamicAnimator:UIDynamicAnimator
    
    var visibleIndexPathsSet:NSMutableSet
    var visibleHeaderAndFooter:NSMutableSet
    var latestDelta:CGFloat
    
    
    required init(coder aDecoder: NSCoder)
    {
        dynamicAnimator = UIDynamicAnimator()
        visibleIndexPathsSet = NSMutableSet()
        visibleHeaderAndFooter = NSMutableSet()
        latestDelta = 0.0
        super.init(coder: aDecoder)
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

    }
    
    
    override func prepareLayout() {
        super.prepareLayout()
        
        var visibleRect = CGRectInset(CGRect(origin: collectionView!.bounds.origin, size: collectionView!.frame.size), -100, -100)
        var itemsInVisibleRectArray:NSArray = super.layoutAttributesForElementsInRect(visibleRect)!
        var itemsIndexPathsInVisibleRectSet = NSSet(array: (itemsInVisibleRectArray.valueForKey("indexPath") as! [AnyObject]))
        
        var noLongerVisibleBehaviours = (self.dynamicAnimator.behaviors as NSArray).filteredArrayUsingPredicate(NSPredicate(block: {behaviour, bindings in
            var currentlyVisible: Bool = itemsIndexPathsInVisibleRectSet.member((behaviour as! UIAttachmentBehavior).items.first!.indexPath) != nil
            return !currentlyVisible
        }))
        
        for (index, obj) in enumerate(noLongerVisibleBehaviours) {
            self.dynamicAnimator.removeBehavior(obj as! UIDynamicBehavior)
            self.visibleIndexPathsSet.removeObject((obj as! UIAttachmentBehavior).items.first!.indexPath)
        }
        
        var newlyVisibleItems = itemsInVisibleRectArray.filteredArrayUsingPredicate(NSPredicate(block: {item, bindings in
            var currentlyVisible: Bool = self.visibleIndexPathsSet.member(item.indexPath) != nil
            return !currentlyVisible
        }))
        
        var touchLocation: CGPoint = self.collectionView!.panGestureRecognizer.locationInView(self.collectionView)
        
        for (index, item) in enumerate(newlyVisibleItems) {
            var springBehaviour: UIAttachmentBehavior = UIAttachmentBehavior(item: item as! UIDynamicItem, attachedToAnchor: item.center)
            
            springBehaviour.length = CGFloat(kLength)
            springBehaviour.damping = CGFloat(kDamping)
            springBehaviour.frequency = CGFloat(kFrequence)
            
            if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
                var yDistanceFromTouch = fabsf(Float(touchLocation.y - springBehaviour.anchorPoint.y))
                var scrollResistance = (yDistanceFromTouch) / Float(kResistence)
                
                var item = springBehaviour.items.first as! UICollectionViewLayoutAttributes
                var center = item.center
                
                if self.latestDelta < 0 {
                    center.y += max(self.latestDelta, self.latestDelta * CGFloat(scrollResistance))
                } else {
                    center.y += min(self.latestDelta, self.latestDelta * CGFloat(scrollResistance))
                }
                
                item.center = center
            }
            
            self.dynamicAnimator.addBehavior(springBehaviour)
            self.visibleIndexPathsSet.addObject(item.indexPath)
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
    
        return dynamicAnimator.itemsInRect(rect)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
    
        var dynamicLayoutAttributes = dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
        
        var r:UICollectionViewLayoutAttributes
        if ((dynamicLayoutAttributes) != nil)
        {
            r = dynamicLayoutAttributes
        }
        else
        {
            r = super.layoutAttributesForItemAtIndexPath(indexPath)
        }
        return r
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        var scrollView = collectionView!
        var delta = newBounds.origin.y - scrollView.bounds.origin.y
        latestDelta = delta
        
        var touchLocation = collectionView!.panGestureRecognizer.locationInView(collectionView)
        for (index, springBehaviour) in enumerate(self.dynamicAnimator.behaviors)
        {
            var x = springBehaviour as! UIAttachmentBehavior
            var distanceFromTouch = fabsf(Float(touchLocation.y - x.anchorPoint.y))
            
            var scrollResistance:Float
            if (self.scrollResistanceFactor != nil)
            {
                scrollResistance = distanceFromTouch/Float(self.scrollResistanceFactor)
            }
            else
            {
                scrollResistance = distanceFromTouch/Float(kScrollResistanceFactorDefault)
            }
            
            var item:UICollectionViewLayoutAttributes = x.items.first as! UICollectionViewLayoutAttributes
            var center = item.center

            if (delta < 0)
            {
                center.y += CGFloat(max(Float(delta), Float(delta)*scrollResistance))
            }
            else
            {
                center.y += CGFloat(min(Float(delta), Float(delta)*scrollResistance))
            }
            
            item.center = center
            
            self.dynamicAnimator .updateItemUsingCurrentState(item)

        }
        
        return false
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        (updateItems as NSArray).enumerateObjectsUsingBlock { (updateItem, idx, stop) -> Void in
            var x = updateItem as! UICollectionViewUpdateItem
            
            if (x.updateAction == UICollectionUpdateAction.Insert)
            {
                if ((self.dynamicAnimator.layoutAttributesForCellAtIndexPath(x.indexPathAfterUpdate!)) != nil)
                {
                    return
                }
                
                var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: x.indexPathAfterUpdate!)
                
                var springBehaviour = UIAttachmentBehavior(item: attributes, attachedToAnchor: attributes.center)
                springBehaviour.length = 1.0
                springBehaviour.damping = 0.8
                springBehaviour.frequency = 1.0
                
                self.dynamicAnimator.addBehavior(springBehaviour)
            }
        }
    }
}
