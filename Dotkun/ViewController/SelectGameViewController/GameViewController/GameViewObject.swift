//
//  GameViewObject.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/07.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import Foundation
import UIKit

class GameViewObject {
    private var _id: ObjectId = 0
    var id: ObjectId {
        set{ _id = newValue }
        get{ return _id }
    }
    
    private var _isVisible: Bool = true
    var isVisible: Bool {
        set{
            _isVisible = newValue
        }
        get{
            return _isVisible
        }
    }
    
    private var _hp: Int = 0
    var hp: Int {
        set{ _hp = newValue }
        get{ return _hp }
    }
    private var spentFrames: Int = 0
    func getSpentFrames()-> Int {
        return spentFrames
    }
    func updateFrame(frameCounter: Int){
        spentFrames = frameCounter
    }
    
    func drawOnContext(context: CGContextRef){
        //抽象クラステーキナー
        fatalError("must be overridden")
    }
}