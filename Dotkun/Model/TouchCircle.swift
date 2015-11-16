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
    
    func getCenterPosition()->CGPoint{
        return self.touchPosition + CGPoint( x: -touchRadius , y: -touchRadius )
    }
}

class TouchCircle : GameViewObject {
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private var color: UIColor! = nil
    private var touchInfo: TouchInfo
    private let growthRate: CGFloat = 5.0
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    override init() {
        color = Constants.TOUCH_CIRCLE_COLOR
        touchInfo = TouchInfo()
    }
    
    //----------------------------------------------------------------
    //Game Logic, Draw Call
    //----------------------------------------------------------------
    override func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        self.color.setFill()
        CGContextFillEllipseInRect(context, CGRectMake(touchInfo.getCenterPosition().x, touchInfo.getCenterPosition().y, touchInfo.touchRadius * 2, touchInfo.touchRadius * 2));
        UIGraphicsPopContext()
    }
    
    func updatePosition(newPosition: CGPoint){
        self.touchInfo.touchPosition = newPosition
    }
    
    func updateTouchInfo(newTouchinfo: TouchInfo){
        self.touchInfo = newTouchinfo
    }
    
    func incrementRadius(){
        self.touchInfo.touchRadius += growthRate
    }
    
    func getTouchInfo()->TouchInfo {
        return touchInfo
    }
    
    func reset(){
        touchInfo.reset()
    }
}