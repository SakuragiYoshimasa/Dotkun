//
//  Dotkun.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

enum DotkunAction {
    case GO
    case BATTLE
    case CHANGE_DIRECTION
}

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
    init(color: UIColor, id: Int) {
        super.init()
        self.color = color
        self.id = id
        var red: CGFloat     = 1.0
        var green: CGFloat   = 1.0
        var blue: CGFloat    = 1.0
        var alpha: CGFloat   = 1.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let sum: CGFloat = sqrt(red * red + green * green + blue * blue)
        if sum != 0 {
            self.hp =  Int(red * 255 / sum) + 100
            self.power = Int(green * 100 / sum) + 10
            self.speed = Int(10 - blue * 10 / sum) + 1
            //print("hp",hp,"  power:",power, "  speed:", speed)
        }else{
            self.hp = 100
            self.power = 10
            self.speed = 11
        }
        if id < GameSettings.DOTKUN_NUM/2 {
            updatePosition(
                id % GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_X_OFFSET,
                y: (id / GameSettings.BATTLEICON_WIDTH) + GameSettings.FIELD_HEIGHT - GameSettings.INITIAL_DOT_Y_OFFSET - GameSettings.BATTLEICON_HEIGHT
            )
            self.direction = Direction.UP
        }else{
            updatePosition(
                id % GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_X_OFFSET,
                y: (id - GameSettings.DOTKUN_NUM/2)/GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_Y_OFFSET
            )
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
            Constants.ALLY_DOTKUN_COLOR.setStroke()
        }else{
            Constants.ENEMY_DOTKUN_COLOR.setStroke()
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
            if targetPosition == fieldPosition {
                targetPosition = nil
            }
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
    
    func isActionFrame(frameCounter: Int)->Bool {
        return (frameCounter % self.speed) == 0
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