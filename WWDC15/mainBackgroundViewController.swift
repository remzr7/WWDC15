//
//  mainBackgroundController.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/19/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit
import AVFoundation


class mainBackgroundController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    @IBOutlet var storiesCollectionView: UICollectionView!
    
    var transition:MagicTransition


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        transition = MagicTransition()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupInits()
    }
     required init(coder aDecoder: NSCoder) {
        transition = MagicTransition()
        super.init(coder:aDecoder)
        setupInits()
        
     }
    
    func setupInits()
    {
        
    }
    
    override func viewDidLoad()
    {
        view.backgroundColor = UIColor.clearColor()
        BackgroundHelper(view: self.view)
        
        setupCollectionView()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setupCollectionView()
    {
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self as UICollectionViewDataSource
    }
    

    
    //MARK: - CollectionView delegate methods
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        var cell:glyphCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("glyph", forIndexPath: indexPath) as! glyphCollectionViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        switch (indexPath.item)
        {
        case 1:
            cell.descLabel.text = "//the.hustler"
            case 2:
                cell.imageView.image = UIImage(named: "engineer")
                cell.descLabel.text = "//the.engineer"
            
                break
            default:
                break
        }
        

        
        
        
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    
    
    
    //MARK: - Gesture Recognizer Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.item)
        {
        case 5:
            transition = MagicTransition(animatedView: collectionView.cellForItemAtIndexPath(indexPath)!)
            break

        default:
            break
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

}

extension mainBackgroundController: UIViewControllerTransitioningDelegate
{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

