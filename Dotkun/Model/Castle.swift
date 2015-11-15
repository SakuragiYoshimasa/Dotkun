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
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private var color: UIColor! = nil
    private var position: CGPoint! = nil
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    init(color: UIColor, pos: CGPoint, id: Int) {
        super.init()
        self.position = pos
        self.id = id
        self.hp = 10000
        self.color = color
        self.fieldPosition = Position(x: 0,y: 0)
    }

    func updatePosition(x: Int, y: Int){
        self.fieldPosition = Position(x: x, y: y)
        self.position = CGPoint(x: CGFloat(x) * GameSettings.DOT_SIZE, y: CGFloat(y) * GameSettings.DOT_SIZE)
    }
    
    //----------------------------------------------------------------
    //
    //----------------------------------------------------------------
    override func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        self.color.setFill()
        CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, GameSettings.DOT_SIZE * CGFloat(GameSettings.CASTLE_SIZE), GameSettings.DOT_SIZE * CGFloat(GameSettings.CASTLE_SIZE)))
        UIGraphicsPopContext()
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
