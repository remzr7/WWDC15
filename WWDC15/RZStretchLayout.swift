//
//  RZStretchLayout.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/26/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit

class RZStretchLayout: UICollectionViewFlowLayout
{
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var collectionView = self.collectionView
        
        var insets = collectionView!.contentInset
        
        var offset = collectionView!.contentOffset
        var minY = -insets.top
        
        if let attributes = super.layoutAttributesForElementsInRect(rect){
        
        
        
        if (offset.y < minY)
        {
            var headerSize = self.headerReferenceSize
            var deltaY = fabsf(Float(offset.y - minY))
            
                for attrs in attributes
                {
                    if(attrs.representedElementCategory != UICollectionElementCategory.Cell)
//                    var elementKind = attrs.representedElementKind as String?
//                        if elementKind? == UICollectionElementKindSectionHeader
                    {
                        var headRect = attrs.frame
                        headRect.size.height = CGFloat(max(Float(minY), Float(headerSize.height) + Float(deltaY)))
                        headRect.origin.y = CGFloat(Float(headRect.origin.y) - Float(deltaY))
                        var z = attrs as! UICollectionViewLayoutAttributes
                        z.frame = headRect
                        break;

                    }
                    
                }
            }
        
        return attributes
        }
        else {return Array()}
    
    }
    
    
    
    
}
