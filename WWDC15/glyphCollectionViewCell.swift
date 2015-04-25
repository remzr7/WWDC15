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

    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.redColor()
    }
}
