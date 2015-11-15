//
//  Dotkun.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class Dotkun: GameViewObject {
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private var color: UIColor! = nil
    private var colorType: ColorType! = nil
    private var power: Int = 0
    private var speed: Int = 0
    private var position: CGPoint! = nil
    private var direction: Direction! = nil
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    init(color: UIColor, pos: CGPoint, id: Int) {
        super.init()
        self.color = color
        self.position = pos
        self.id = id
        self.hp = 100
        self.power = 25
        self.speed = 10
        self.fieldPosition = Position(x: 0,y: 0)
        if id < GameSettings.DOTKUN_NUM/2 {
            self.direction = Direction.UP
        }else{
            self.direction = Direction.DOWN
        }
    }
    
    //----------------------------------------------------------------
    //Game Logic, Draw Call
    //----------------------------------------------------------------
    override func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        
        self.color.setFill()
        CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, 6, 6))
        
        if self.id.getObjectType() == FieldState.ALLY {
            UIColor.brownColor().setStroke()
        }else{
            UIColor.redColor().setStroke()
        }
        if self.targetPosition != nil{
            UIColor.blueColor().setStroke()
        }
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
    
    func updatePosition(x: Int, y: Int){
        self.fieldPosition = Position(x: x, y: y)
        self.position = CGPoint(x: (CGFloat(x) + 0.5) * GameSettings.DOT_SIZE, y: (CGFloat(y) + 0.5) * GameSettings.DOT_SIZE)
    }
    
    func updatePosition(){
        self.fieldPosition? += self.direction.getPositionValue()
        updatePosition(fieldPosition.x, y: fieldPosition.y)
    }
    
    func updateDirection(){
        if targetPosition != nil {
            direction = GameUtils.GetTargetDirection(fieldPosition, targetPos: targetPosition)
        }
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
    
    func battleWith(enemy: GameViewObject) {
        enemy.hp -= self.power
    }
    
    func isActionFrame()->Bool {
        return (getSpentFrames() % self.speed) == 0
    }
    
    func changeDirection() {
        direction = Direction(rawValue: (direction.rawValue + 1) % 4)
    }
    
    func checkAlive()->Bool {
        return self.hp > 0
    }
}

enum ColorType {
    
}