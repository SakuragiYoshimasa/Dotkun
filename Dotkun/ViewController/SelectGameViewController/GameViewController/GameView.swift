//
//  GameView.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit


// Viewに関する部分のみ扱う、ゲームのロジックは書かない
class GameView: UIView {
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private var objects: [GameViewObject] = []
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //----------------------------------------------------------------
    //Manupurate Objects
    //----------------------------------------------------------------
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
            if !object.isVisible {continue}
            object.drawOnContext(context!)
        }
    }
}