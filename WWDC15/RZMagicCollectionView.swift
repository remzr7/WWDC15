//
//  RZMagicCollectionView.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/25/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit

class RZMagicCollectionView: UICollectionView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var layout = RZMagicLayout(coder: aDecoder)
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 50
        layout.sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)

        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        self.backgroundColor = UIColor.clearColor()

        
    }


}

 protocol RZMagicTransform
{
    var miniumScale:CGFloat {get};
    func transformCell(forScale scale:CGFloat);
}

extension RZMagicCollectionView
{
    
    override func layoutSubviews() {
        
        super.layoutSubviews();
        self.transformz()
    }
     func transformz()
    {
        for indexPath in indexPathsForVisibleItems() as! [NSIndexPath]
        {
            if let cell = cellForItemAtIndexPath(indexPath) as? RZMagicTransform
            {
                let distanceFromCenter = calcDistanceFromCenter(indexPath)
                cell.transformCell(forScale: scale(distanceFromCenter, minScale:cell.miniumScale))
            }
            
        }
    }
    
     func calcDistanceFromCenter(indexPath:NSIndexPath) -> CGFloat
    {
        let cellRect = self.cellForItemAtIndexPath(indexPath)?.frame
        let cellCenter = cellRect!.origin.y + cellRect!.size.height/2;
        let contentCenter = self.contentOffset.y + self.bounds.size.height/2;
        
        var x = fabs(cellCenter - contentCenter);
        NSLog("Distance From Centre is", x)
        return x
    }
    
     func scale(distanceFromCenter:CGFloat, minScale:CGFloat) -> CGFloat{
        
        return (1 - minScale) * distanceFromCenter / bounds.height
    }
}
