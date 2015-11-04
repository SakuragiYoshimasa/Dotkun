//
//  GameView.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

protocol GameViewObject {
    func drawOnContext(context: CGContextRef)
}

class GameView: UIView {
    private var objects: [GameViewObject] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addObject(object: GameViewObject) {
        self.objects.append(object)
    }
    
    func clear() {
        self.objects = []
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        self.backgroundColor?.setFill()
        CGContextFillRect(context!, self.bounds)
        
        for object in objects {
            object.drawOnContext(context!)
        }
    }
}