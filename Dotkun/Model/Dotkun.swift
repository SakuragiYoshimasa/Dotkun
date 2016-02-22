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

class Dotkun: GameObject {
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private var color: UIColor! = nil
    private var colorType: ColorType! = nil
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    init(color: UIColor, id: Int, pos: Position) {
        super.init()
        self.color = color
        self.id = id
        self.calculateParameters(color)
        self.fieldPosition = pos
        self.speed = 1
    }
    
    func calculateParameters(color: UIColor) {
        let (red, green, blue, _) = color.getRGBA()
        let sum: CGFloat = sqrt(red * red + green * green + blue * blue)
        if sum != 0 {
            self.hp =  Int(red * 255 / sum) + 100
            self.power = Int(green * 100 / sum) + 10
            self.actionPeriod = Int(10 - blue * 10 / sum) + 1
        }else{
            self.hp = 100
            self.power = 10
            self.actionPeriod = 11
        }
        
        print("hp:\(hp) power:\(power) speed:\(speed)")
    }
    
    //----------------------------------------------------------------
    //Game Logic, Draw Call
    //----------------------------------------------------------------
    override func drawOnContext(context: CGContextRef) {
        
        let pos = fieldPosition
        
        let position = CGPoint(x: (CGFloat(pos.x) + 0.5) * GameSettings.DOT_SIZE, y: (CGFloat(pos.y) + 0.5) * GameSettings.DOT_SIZE)
    
        UIGraphicsPushContext(context)
        
        self.color.setFill()
        CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, 6, 6))
        
        if self.type == FieldState.ALLY {
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
    
    func getDirection() -> Direction {
        return direction
    }
    func setDirection(direction: Direction) {
        self.direction = direction
    }
    
    func changeDirection() {
        direction = Direction(rawValue: (direction.rawValue + 1) % 4)!
    }
}

enum ColorType {
    
}