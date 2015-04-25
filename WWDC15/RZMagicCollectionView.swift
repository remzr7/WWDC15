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
