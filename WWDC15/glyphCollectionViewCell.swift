//
//  glyphCollectionViewCell.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/21/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit

class glyphCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descLabel: UILabel!

    @IBOutlet var shadowImage: UIImageView!
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        

    }
    
    override func layoutSubviews() {
        backgroundColor = UIColor.redColor()
//        shadowImage.frame = frame;
    }
    
    
}
