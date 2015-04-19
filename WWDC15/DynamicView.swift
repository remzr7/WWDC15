//
//  DyanmicView.swift
//  WWDC15
//
//  Created by Rameez Remsudeen  on 4/17/15.
//  Copyright (c) 2015 Rameez Remsudeen. All rights reserved.
//

import UIKit
import QuartzCore

class DynamicView: UIView, DynamicDelegate, UIDynamicAnimatorDelegate {
    
    @IBInspectable var frequency: CGFloat = 3;
    
    @IBInspectable var damping: CGFloat = 0.3;
    
    @IBInspectable var edges: ViewEdge = ViewEdge.all;
    
    
    
    required init(coder aDecoder:NSCoder){
        
        super.init(coder: aDecoder)
        
        setup()
        
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        
        setup()
    }
    
    
    func setup()
    {
        layer.masksToBounds = false
        layer.addSublayer(maskLayer)
        (layer as! DynamicLayer).dynamicDelegate = self
        
        setupVertices()
        setupMidpoints()
        setupCenter()
        setupBehaviours()
        setupDiplayLink()
        
        
    }
    
    func setupVertices()
    {
        vertexViews = []
        
        let vertexOrigins = [CGPoint(x: frame.origin.x, y: frame.origin.y),
            CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y),
            CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height),
            CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height)]
        
        createAdditionalViews(&vertexViews, origins: vertexOrigins)
        
        
        
    }
    
    func setupMidpoints()
    {
        midpointViews = []
        
        let midpointOrigins = [CGPoint(x: frame.origin.x + frame.width/2, y: frame.origin.y),
            CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height/2),
            CGPoint (x: frame.origin.x + frame.width, y: frame.origin.y + frame.height/2),
            CGPoint(x: frame.origin.x + frame.width/2, y: frame.origin.y + frame.height)]
        
        createAdditionalViews(&midpointViews, origins: midpointOrigins)
    }
    
    func setupCenter()
    {
        var centerOrigin = CGPoint(x: frame.origin.x + frame.width/2, y: frame.origin.y + frame.height)
        
        centerView = UIView(frame: CGRect(origin: centerOrigin, size: CGSizeMake(1, 1)))
        centerView.backgroundColor = UIColor.clearColor()
        addSubview(centerView)
    }
    
    func setupBehaviours()
    {
        animator = UIDynamicAnimator(referenceView: self)
        animator!.delegate = self
        verticeAttachments = []
        centerAttachments = []
        
        for (i, midpointView) in enumerate(midpointViews)
        {
            let formerVertexIndex = i
            let nextVertexIndex = (i+1) % vertexViews.count
            
            createVertexAttachment(midpointView, vertexIndex: formerVertexIndex)
            createVertexAttachment(midpointView, vertexIndex: nextVertexIndex)
            createCenterAttachment(midpointView)
        }
    }
    
    func setupDiplayLink()
    {
        displayLink = CADisplayLink(target: self, selector: "displayLinkUpdate:")
        displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink!.paused = true
        
        
    }
    
    //Mark: CADisplayLink selector
    
    func displayLinkUpdate(sender: CADisplayLink)
    {
        for behavior in centerAttachments {
            behavior.anchorPoint = centerView.layer.presentationLayer().frame.origin
        
        }
        
        for behavior in verticeAttachments{
            behavior.anchorPoint = vertexViews[behavior.vertexIndex!].layer.presentationLayer().frame.origin
        }
        
        var bezierPath = UIBezierPath()
        
        var x = vertexViews[0].layer.presentationLayer().frame.origin
        var y = layer.presentationLayer().frame.origin
        var z:CGPoint = x-y
        
        bezierPath.moveToPoint(z)
        
        addEdge(&bezierPath, formerVertex: 0, nextVertex: 1, curved: edges & ViewEdge.top)
        addEdge(&bezierPath, formerVertex: 1, nextVertex: 2, curved: edges & ViewEdge.right)
        addEdge(&bezierPath, formerVertex: 2, nextVertex: 3, curved: edges & ViewEdge.bottom)
        addEdge(&bezierPath, formerVertex: 3, nextVertex: 0, curved: edges & ViewEdge.left)
        bezierPath.closePath()
        
        maskLayer.path = bezierPath.CGPath
        (layer as! CAShapeLayer).path = bezierPath.CGPath
        layer.mask = maskLayer
        
    }
    
    //MARK:Overrides
    
    override var backgroundColor: UIColor?{
        
        didSet{
            (layer as! CAShapeLayer).fillColor = backgroundColor?.CGColor
        }
    }
    
    override class func layerClass() -> AnyClass
    {
        return DynamicLayer.self
    }
    
    //MARK: Helper methods
    
    func createAdditionalViews(inout views: [UIView], origins: [CGPoint])
    {
        for origin in origins
        {
            var view = UIView(frame: CGRect(origin: origin, size: CGSize(width:1, height:1)))
            view.backgroundColor = UIColor.clearColor()
            addSubview(view)
            views.append(view)
        }
    }
    
    func createVertexAttachment(view: UIView, vertexIndex: Int)
    {
        var formerVertexAttachment = MidpointAttachmentBehavior(item: view, attachedToAnchor: vertexViews[vertexIndex].frame.origin)
        formerVertexAttachment.damping = damping
        formerVertexAttachment.frequency = frequency
        formerVertexAttachment.vertexIndex = vertexIndex
        animator?.addBehavior(formerVertexAttachment)
        
        verticeAttachments.append(formerVertexAttachment)
        
    }
    
    func createCenterAttachment(view: UIView)
    {
        var centerAttachment = UIAttachmentBehavior(item: view, attachedToAnchor: view.frame.origin)
        centerAttachment.damping = damping
        centerAttachment.frequency = frequency
        animator!.addBehavior(centerAttachment)
        
        centerAttachments.append(centerAttachment)
    }
    
    func addEdge(inout bezierPath: UIBezierPath, formerVertex:Int, nextVertex:Int, curved:ViewEdge)
    {
        if(curved)
        {
            var controlPoint = (vertexViews[formerVertex].layer.presentationLayer().frame.origin - (midpointViews[formerVertex].layer.presentationLayer().frame.origin - vertexViews[nextVertex].layer.presentationLayer().frame.origin)) - layer.presentationLayer().frame.origin
            bezierPath.addQuadCurveToPoint(vertexViews[nextVertex].layer.presentationLayer().frame.origin - layer.presentationLayer().frame.origin,
                controlPoint: controlPoint)
            
            return;
        }
    }
    
    
    //MARK: Private Variables
    
    private var vertexViews:[UIView] = []
    private var midpointViews:[UIView] = []
    private var centerView:UIView = UIView()
    private var animator:UIDynamicAnimator?
    private var displayLink:CADisplayLink?
    private var maskLayer:CAShapeLayer = CAShapeLayer()
    private var verticeAttachments:[MidpointAttachmentBehavior] = []
    private var centerAttachments:[UIAttachmentBehavior] = []
    
    

}
//MARK: UIDynamicAnimatorDelegate

extension DynamicView: UIDynamicAnimatorDelegate
{
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        
        displayLink!.paused = true
    }
}

//MARK: Dynamic Delegate
extension DynamicView: DynamicDelegate
{
    func positionChanged()
    {
        
        displayLink?.paused = false
        let verticeOrigins = [CGPoint(x: frame.origin.x, y: frame.origin.y), CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y),
            CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height),
            CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height)]
        
        for (i, vertexView) in enumerate(vertexViews)
        {
            vertexView.frame.origin = verticeOrigins[i]
        }
        
        centerView.frame.origin = CGPoint(x: frame.origin.x + frame.width/2, y:frame.origin.y + frame.height/2)
        
    }
}


private protocol DynamicDelegate
{
    func positionChanged()

}
//MARK: - Helper Classes

infix operator - {associativity left precedence 160}

private func - (left:CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x:left.x - right.x, y:left.y - right.y)
}

private class DynamicLayer:CAShapeLayer
{
    var dynamicDelegate: DynamicDelegate?
    
    @objc override var position:CGPoint{
        didSet{
            dynamicDelegate?.positionChanged()
            
        }
    }
}

struct ViewEdge : RawOptionSetType, BooleanType
{
    private var value: UInt = 0
    
    init(nilLiteral: ()) {
    
    }
    
    init(rawValue value:UInt){
        self.value = value
    }
    
    var boolValue: Bool{
        return value != 0
    }
    
    var rawValue: UInt{
        return value
    }
    
    static var allZeros: ViewEdge {
        return self(rawValue: 0)
    }
    
    static var left: ViewEdge{
        return self(rawValue: 0b0001)
    }
    
    static var top: ViewEdge {
        return self(rawValue: 0b0010)
    }
    
    static var right: ViewEdge {
        return self(rawValue: 0b0100)
    }
    
    static var bottom: ViewEdge {
        return self(rawValue: 0b1000)
    }
    
    static var all: ViewEdge {
        return self(rawValue: 0b1111)
    }

}


private class MidpointAttachmentBehavior: UIAttachmentBehavior
{
    var vertexIndex:Int?
}

