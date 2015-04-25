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

class RZMagicLayout: UICollectionViewLayout
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
        var itemsInVisibleRectArray = super.layoutAttributesForElementsInRect(visibleRect)
        var itemsIndexPathsInVisibleRectSet = NSSet(array: ((itemsInVisibleRectArray! as NSArray).valueForKey("indexPath") as! Array))
        
        var noLongerVisibleBehaviours:Array = dynamicAnimator.behaviors.filter({
            (behaviour:AnyObject) -> Bool in
            
            var x = behaviour as! UIAttachmentBehavior
            
            return (itemsInVisibleRectArray! as NSArray).containsObject(((x.items.first)! as! UICollectionViewLayoutAttributes).indexPath) == false
            
        })
        
        (noLongerVisibleBehaviours as NSArray).enumerateObjectsUsingBlock ({ obj, index, stop in
            
            var x = obj as! UIAttachmentBehavior
            self.dynamicAnimator.removeBehavior(x)
            
            
            self.visibleIndexPathsSet.removeObject(NSIndexPath(index: index))
            self.visibleHeaderAndFooter.removeObject(NSIndexPath(index: index))
        })
        
        var newlyVisibleItems = itemsInVisibleRectArray?.filter({
            (item:AnyObject) -> Bool in
            
            var x = item as! UICollectionViewLayoutAttributes
            
            var f:AnyObject;
            
            
            if (item.representedElementKind as AnyObject === (UICollectionElementCategory.Cell as! AnyObject))
            {
                f = (self.visibleIndexPathsSet.containsObject(item.indexPath) as Bool) == false
            }
            else
            {
                f = (self.visibleHeaderAndFooter.containsObject(item.indexPath) as Bool) == false
            }
            
            return f as! Bool
        })
        
        var touchLocation = collectionView?.panGestureRecognizer.locationInView(collectionView)
        
        (newlyVisibleItems! as NSArray).enumerateObjectsUsingBlock { (item, idx, stop) -> Void in
            var x = item as! UICollectionViewLayoutAttributes
            var center = x.center
            var springBehaviour = UIAttachmentBehavior(item: x, attachedToAnchor: center)
            
            springBehaviour.length = 1.0
            springBehaviour.damping = 0.8
            springBehaviour.frequency = 1.0
            
            if (!CGPointEqualToPoint(CGPointZero, touchLocation!)){
                
                var distanceFromTouch = fabsf(Float(touchLocation!.y - springBehaviour.anchorPoint.y))
                var scrollResistance:Float
                
                var f = Float(self.latestDelta)
                if ((self.scrollResistanceFactor) != nil)
                {
                    var z = Float(self.scrollResistanceFactor)
                    scrollResistance = distanceFromTouch/z
                }
                else
                {
                    var z = Float(kScrollResistanceFactorDefault)
                    scrollResistance = distanceFromTouch/z
                }
                
                if (self.latestDelta < 0)
                {
                    center.y += CGFloat(max(f, f * scrollResistance))
                }
                else
                {
                    center.y += CGFloat(min(f, f * scrollResistance))
                    
                    
                }
                
                x.center = center
            }
            
            self.dynamicAnimator.addBehavior(springBehaviour)
            
            if(item.representedElementCategory == UICollectionElementCategory.Cell)
            {
                self.visibleIndexPathsSet.addObject(x.indexPath)
            }
            else
            {
                self.visibleHeaderAndFooter.addObject(x.indexPath)
            }

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
        var scrollView = collectionView
        var delta = newBounds.origin.y - scrollView!.bounds.origin.y
        latestDelta = delta
        
        var touchLocation = collectionView?.panGestureRecognizer.locationInView(collectionView)
        
        (dynamicAnimator.behaviors as NSArray) .enumerateObjectsUsingBlock { (springBehaviour, idx, stop) -> Void in
            var x = springBehaviour as! UIAttachmentBehavior
            
            var distanceFromTouch = fabsf(Float(touchLocation!.y - x.anchorPoint.y))
            
            var scrollResistance:Float
            if (self.scrollResistanceFactor != nil)
            {
                scrollResistance = distanceFromTouch/Float(self.scrollResistanceFactor)
            }
            else
            {
                scrollResistance = distanceFromTouch/Float(kScrollResistanceFactorDefault)
            }
            
            var item:UICollectionViewLayoutAttributes = (x.items.first as! UICollectionViewLayoutAttributes)
            var center = item.center
            
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
