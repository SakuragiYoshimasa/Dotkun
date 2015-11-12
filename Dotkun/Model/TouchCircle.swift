//
//  touchCircle.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/11.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//
import Foundation
import UIKit

struct TouchInfo {
    var touchRadius: CGFloat = 0
    var touchPosition: CGPoint! = CGPoint(x: 0,y: 0)
    
    mutating func reset(){
        self.touchRadius = 0
        self.touchPosition = CGPoint(x: 0, y: 0)
    }
}

class TouchCircle : GameViewObject {
    private var color: UIColor! = nil
   
    public var touchInfo: TouchInfo
    
    override func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        //self.color.set()
        self.color.setFill()
        CGContextFillEllipseInRect(context, CGRectMake(getCenterPosition().x, getCenterPosition().y, touchInfo.touchRadius, touchInfo.touchRadius));
        //CGContextAddEllipseInRect(CGContext?, <#T##rect: CGRect##CGRect#>)
        
        UIGraphicsPopContext()
    }
    
    override init() {
        color = Constants.BACKCOLOR
        touchInfo = TouchInfo()
    }
    
    func updatePosition(newPosition: CGPoint){
        self.touchInfo.touchPosition = newPosition
            //+ CGPoint( x: -touchInfo.touchRadius / 2.0, y: -touchInfo.touchRadius / 2.0)
    }
    
    func updateTouchInfo(newTouchinfo: TouchInfo){
        self.touchInfo = newTouchinfo
    }
    
    func getCenterPosition() -> CGPoint{
        return self.touchInfo.touchPosition + CGPoint( x: -touchInfo.touchRadius / 2.0, y: -touchInfo.touchRadius / 2.0)
    }
    
   /* func getTouchInfo()->TouchInfo {
        return touchInfo
    }*/
}