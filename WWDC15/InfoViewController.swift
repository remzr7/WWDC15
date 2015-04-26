//
//  InfoViewController.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/26/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var flexLayout: RZStretchLayout!
    @IBOutlet var collectionView: UICollectionView!
    
    var hasScrolled:Bool
    var header:UICollectionReusableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        hasScrolled = false

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        hasScrolled = false
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.clearColor()
        
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        
        visualEffectView.frame = self.view.bounds
        
        view.insertSubview(visualEffectView, atIndex: 0)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flexLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flexLayout.itemSize = CGSizeMake(300.0, 494.0)
        flexLayout.headerReferenceSize = CGSizeMake(320.0, 160.0)
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.delegate = self
        collectionView.dataSource = self as UICollectionViewDataSource
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)  as! UICollectionViewCell
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: "Header",
                forIndexPath: indexPath) as! UICollectionReusableView
            var bounds = header.bounds
            
            var imageView = UIImageView(frame: bounds)
            imageView.image = UIImage(named:"engineer")
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            
            imageView.autoresizingMask =  UIViewAutoresizing.FlexibleHeight
            imageView.clipsToBounds = true
            header.addSubview(imageView)
            
        
        return header
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
