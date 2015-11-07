//
//  Dotkun.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

struct Position {
    var x: Int
    var y: Int
}

enum Direction {
    case UP
    case RIGHT
    case DOWN
    case LEFT
}


class Dotkun: GameViewObject {
    // 管理用
    private var ID: Int = 0
    
    private var color: UIColor! = nil
    private var colorType: ColorType! = nil
   
    private var position: CGPoint! = nil
    
    private var power: Int! = nil
    private var hp: Int! = nil
    private var speed: CGFloat! = nil
    
    private var fieldPosition: Position! = nil
    private var targetPosition: Position! = nil
    private var direction: Direction! = nil
    
    
    init(color: UIColor, pos: CGPoint) {
        self.color = color
        self.position = pos
        self.direction = Direction.UP
    }
    
    func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        
        self.color.setFill()
        //CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, 6, 6))
        
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
    
    
    func move(x: CGFloat, y: CGFloat) {
        self.position.move(x, y: y)
    }
    
    init() {
    }
    
    func setIndex(i: Int){
        ID = i
    }
    
    func updatePosition(x: Int, y: Int){
        self.position = CGPoint(x: x * GameSettings.DOT_SIZE, y: y * GameSettings.DOT_SIZE)
    }
    
    func updateDirection(){
        if targetPosition == nil {
            
        }
    }
}

enum ColorType {
    
}