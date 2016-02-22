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
    private var castleImage: UIImage! = nil
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    init(color: UIColor, pos: Position, id: Int) {
        super.init()
        self.id = id
        self.hp = GameSettings.HP_CASTLE
        self.color = color
        self.fieldPosition = pos
        
        // 無関係
        self.speed = 0
        self.direction = Direction.UP
        self.actionPeriod = 1
        self.castleImage = UIImage(named: "castle.png")
    }

    func updatePosition(x: Int, y: Int){
        self.fieldPosition = Position(x: x, y: y)
    }
    
    //----------------------------------------------------------------
    //
    //----------------------------------------------------------------
    override func drawOnContext(context: CGContextRef) {
        let pos = self.fieldPosition
        UIGraphicsPushContext(context)
        self.color.setFill()
        let castleRect = CGRect(origin: CGPoint(x: CGFloat(pos.x) * GameSettings.DOT_SIZE, y: CGFloat(pos.y) * GameSettings.DOT_SIZE), size: CGSize(width: GameSettings.DOT_SIZE * CGFloat(GameSettings.CASTLE_SIZE), height: GameSettings.DOT_SIZE * CGFloat(GameSettings.CASTLE_SIZE)))
        CGContextFillRect(context, castleRect)
        castleImage.drawInRect(castleRect)
        UIGraphicsPopContext()
    }
}
