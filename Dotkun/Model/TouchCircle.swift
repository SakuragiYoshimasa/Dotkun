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
        self.color.setFill()
        //CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, CGFloat(GameSettings.DOT_SIZE * GameSettings.CASTLE_SIZE), CGFloat(GameSettings.DOT_SIZE * GameSettings.CASTLE_SIZE)))
        CGContextFillEllipseInRect(context, CGRectMake(touchInfo.touchPosition.x, touchInfo.touchPosition.y, touchInfo.touchRadius, touchInfo.touchRadius));
        //CGContextFillEllipseInRect(context, CGRectMake(touchInfo.touchPosition.x, touchInfo.touchPosition.y, 100, 100));
        UIGraphicsPopContext()
    }
    
    override init() {
        color = Constants.BACKCOLOR
        touchInfo = TouchInfo()
    }
    
    func updatePosition(newPosition: CGPoint){
        //position = newPosition
    }
    
    func updateTouchInfo(newTouchinfo: TouchInfo){
        self.touchInfo = newTouchinfo
    }
    
   /* func getTouchInfo()->TouchInfo {
        return touchInfo
    }*/
}