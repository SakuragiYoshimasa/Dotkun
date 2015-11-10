//
//  Dotkun.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class Dotkun: GameViewObject {
    
    private var color: UIColor! = nil
    private var colorType: ColorType! = nil
    private var power: Int = 0
    private var speed: Int = 0
    
    private var position: CGPoint! = nil
    private var fieldPosition: Position! = nil
    private var targetPosition: Position! = nil
    private var direction: Direction! = nil
    
    init(color: UIColor, pos: CGPoint, id: Int) {
        super.init()
        self.color = color
        self.position = pos
        self.id = id
        self.hp = 100
        self.power = 25
        self.speed = 2
        if id < GameSettings.DOTKUN_NUM/2 {
            self.direction = Direction.UP
        }else{
            self.direction = Direction.DOWN
        }
    }
    
    override func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        
        self.color.setFill()
        CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, 6, 6))
        
        if self.id.getObjectType() == FieldState.ALLY {
            UIColor.brownColor().setStroke()
        }else{
            UIColor.redColor().setStroke()
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
    
    override init() {
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
        if targetPosition != nil {
            
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
    
    //端に行った時用、とリあえず回す
    func changeDirection() {
        direction = Direction(rawValue: (direction.rawValue + 1) % 4)
    }
    
    func checkAlive()->Bool {
        return self.hp > 0
    }
}

enum ColorType {
    
}