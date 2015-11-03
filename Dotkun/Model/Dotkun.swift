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
    private var index: Int = 0
    
    private var color: UIColor! = nil
    private var colorType: ColorType! = nil
    private var position: CGPoint! = nil
    
    private var power: Int! = nil
    private var hp: Int! = nil
    private var speed: CGFloat! = nil
    
    init(color: UIColor, pos: CGPoint) {
        self.color = color
        self.position = pos
    }
    
    func drawOnContext(context: CGContextRef) {
        UIGraphicsPushContext(context)
        
        self.color.setFill()
        CGContextFillRect(context, CGRectMake(position.x-3, position.y-3, 6, 6))
        
        UIGraphicsPopContext()
    }
    
    func move(x: CGFloat, y: CGFloat) {
        self.position.move(x, y: y)
    }
    
    init() {
        
    }
}

enum ColorType {
    
}