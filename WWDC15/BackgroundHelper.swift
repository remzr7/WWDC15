//
//  BackgroundHelper.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/21/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit
import AVFoundation

class BackgroundHelper: NSObject {
    
    init(view:UIView)
    {
        super.init()
        
        setupBackgroundVideo(view)
    }
    
    
    func setupBackgroundVideo(view:UIView)
    {
        let filePath:NSURL = NSBundle.mainBundle().URLForResource("bgEffect", withExtension: "mp4")!
        
        let player:AVPlayer = AVPlayer(URL: filePath)
        
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("playerItemDidEnd:"), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = view.frame
        
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.insertSublayer(playerLayer, atIndex: 0)
        
        player.play()
        
        NSLog("played")
        
    }
    
    
    //MARK: - Target Actions

    func playerItemDidEnd(notification: NSNotification)
    {
        let player = notification.object as! AVPlayerItem
        player.seekToTime(kCMTimeZero)
    }
    

}
