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
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        self.backgroundColor = UIColor.clearColor()
        self.registerClass(glyphCollectionViewCell.self, forCellWithReuseIdentifier: "glyph")

        
    }


}
