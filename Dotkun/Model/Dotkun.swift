//
//  Dotkun.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class Dotkun: GameViewObject {
    // 管理用
    private var _id: Int = 0
    var id: Int {
        set{
            _id = newValue
        }
        get{
            return _id
        }
    }
    
    private var color: UIColor! = nil
    private var colorType: ColorType! = nil
   
    private var power: Int! = nil
    private var hp: Int! = nil
    private var speed: CGFloat! = nil
    
    private var position: CGPoint! = nil
    private var fieldPosition: Position! = nil
    private var targetPosition: Position! = nil
    private var direction: Direction! = nil
    
    private var spentFrames: Int = 0
    
    init(color: UIColor, pos: CGPoint, id: Int) {
        self.color = color
        self.position = pos
        self._id = id
        if id < GameSettings.DOTKUN_NUM/2 {
            self.direction = Direction.UP
        }else{
            self.direction = Direction.DOWN
        }
    }
    
    func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        
        self.color.setFill()
        CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, 6, 6))
        
        UIColor.brownColor().setStroke()
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
        
        // 描画
        CGContextStrokePath(context)
        
        UIGraphicsPopContext()
    }
    
    init() {
        fieldPosition = Position(x: 0,y: 0)
    }
    
    func updatePosition(x: Int, y: Int){
        self.fieldPosition = Position(x: x, y: y)
        self.position = CGPoint(x: x * GameSettings.DOT_SIZE, y: y * GameSettings.DOT_SIZE)
    }
    
    func updatePosition(){
        self.fieldPosition? += self.direction.getPositionValue()
        updatePosition(fieldPosition.x, y: fieldPosition.y)
    }
    
    func updateDirection(){
        if targetPosition == nil {
            
        }
    }
    
    func updateFrame(frameCounter: Int){
        spentFrames = frameCounter
    }
    
    func getPosition()->Position {
        if fieldPosition == nil {
            fieldPosition = Position(x:0, y:0)
        }
        return self.fieldPosition
    }
    
    func getDirection()->Direction {
        return direction
    }
    
    func getSpentFrames()-> Int {
        return spentFrames
    }
    
    func battleWith(enemy: Dotkun) {
        //---------------------
    }
    
    //端に行った時用、とリあえず回す
    func changeDirection() {
        direction = Direction(rawValue: (direction.rawValue + 1) % 4)
    }
}

enum ColorType {
    
}