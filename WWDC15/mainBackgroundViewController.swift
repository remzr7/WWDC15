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
  
    var panGestureRecognizer:UIPanGestureRecognizer!


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupInits()
    }
     required init(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        setupInits()
     }
    
    func setupInits()
    {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleGesture")
    }
    
    override func viewDidLoad()
    {
        view.backgroundColor = UIColor.clearColor()
        BackgroundHelper(view: self.view)
        
        setupCollectionView()

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
        
        cell.backgroundColor = UIColor.blueColor()
        
        
        
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    
    //MARK: - Gesture Recognizer Methods
    
    func handleGesture(sender:AnyObject)
    {
        
    }
    

}

