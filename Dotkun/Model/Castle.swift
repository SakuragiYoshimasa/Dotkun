//
//  Castle.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/08.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import Foundation

import UIKit

class Castle: GameViewObject {
    
    private var color: UIColor! = nil

    private var position: CGPoint! = nil
    private var fieldPosition: Position! = nil
    
    init(color: UIColor, pos: CGPoint, id: Int) {
        super.init()
        self.position = pos
        self.id = id
        self.hp = 1000
        self.color = color
    }
    
    override func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        
        self.color.setFill()
        CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, CGFloat(GameSettings.DOT_SIZE * 3), CGFloat(GameSettings.DOT_SIZE * 3)))
        
        /*UIColor.brownColor().setStroke()
        CGContextSetLineWidth(context, 1)
        // 首
        CGContextMoveToPoint(context, position.x, position.y+3)
        // 股
        CGContextAddLineToPoint(context, position.x, position.y+8)
        // 右足の先
        CGContextAddLineToPoint(context, position.x+3, position.y+11)
        // 股
        CGContextMoveToPoint(context, position.x, position.y+8)
        // 左足の先
        CGContextAddLineToPoint(context, position.x-3, position.y+11)
        
        // 左腕の先
        CGContextMoveToPoint(context, position.x-3, position.y+5)
        // 右腕の先
        CGContextAddLineToPoint(context, position.x+3, position.y+5)
        */
        // 描画
        CGContextStrokePath(context)
        
        UIGraphicsPopContext()
    }
    
    override init() {
        fieldPosition = Position(x: 0,y: 0)
    }
    
    func updatePosition(x: Int, y: Int){
        self.fieldPosition = Position(x: x, y: y)
        self.position = CGPoint(x: x * GameSettings.DOT_SIZE, y: y * GameSettings.DOT_SIZE)
    }
 
    func getPosition()->Position {
        if fieldPosition == nil {
            fieldPosition = Position(x:0, y:0)
        }
        return self.fieldPosition
    }
    
    func checkAlive()->Bool {
        return self.hp > 0
    }
}
