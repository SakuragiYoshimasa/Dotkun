//
//  Castle.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/08.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import Foundation

import UIKit

class Castle: GameObject {
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private var color: UIColor! = nil
    private var position: CGPoint {
        return CGPoint(x: CGFloat(self.fieldPosition.x) * GameSettings.DOT_SIZE, y: CGFloat(self.fieldPosition.y) * GameSettings.DOT_SIZE)
    }
    private var castleImage: UIImage! = nil
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    init(color: UIColor, pos: Position, id: Int) {
        super.init()
        self.id = id
        self.hp = 100000
        self.color = color
        self.fieldPosition = pos
        self.castleImage = UIImage(named: "castle.png")
    }

    func updatePosition(x: Int, y: Int){
        self.fieldPosition = Position(x: x, y: y)
    }
    
    //----------------------------------------------------------------
    //
    //----------------------------------------------------------------
    override func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        self.color.setFill()
        CGContextFillRect(context, CGRectMake(position.x, position.y, GameSettings.DOT_SIZE * CGFloat(GameSettings.CASTLE_SIZE), GameSettings.DOT_SIZE * CGFloat(GameSettings.CASTLE_SIZE)))
        UIGraphicsPopContext()
        castleImage.drawInRect(CGRectMake(position.x, position.y, GameSettings.DOT_SIZE * CGFloat(GameSettings.CASTLE_SIZE), GameSettings.DOT_SIZE * CGFloat(GameSettings.CASTLE_SIZE)))
    }
    func getPosition() -> Position {
        if fieldPosition == nil {
            fieldPosition = Position(x:0, y:0)
        }
        return self.fieldPosition
    }
}
