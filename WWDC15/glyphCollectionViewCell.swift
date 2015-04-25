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
    let miniumScale:CGFloat = 0.70;
    @IBOutlet weak var scaleView: UIView!

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

    }
    
    
}

extension glyphCollectionViewCell: RZMagicTransform
{

    override func prepareForReuse() {
        super.prepareForReuse();
        scaleView.transform = CGAffineTransformMakeScale(self.miniumScale, self.miniumScale);
    }
    
    func transformCell(forScale scale: CGFloat) {
        self.scaleView.transform = CGAffineTransformMakeScale(1.0 - scale, 1.0 - scale);
    }

}
