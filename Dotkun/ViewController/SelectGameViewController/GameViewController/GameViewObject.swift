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
    
    private var _isVisible: Bool = true
    var isVisible: Bool {
        set{
            _isVisible = newValue
        }
        get{
            return _isVisible
        }
    }
    
    //----------------------------------------------------------------
    // Method
    //----------------------------------------------------------------
    func drawOnContext(context: CGContextRef){
        fatalError("drawOnContext method has not been implemented.")
    }
}

class GameObject: GameViewObject {
    //----------------------------------------------------------------
    // Variable
    //----------------------------------------------------------------
    private var _id: ObjectId = 0
    var id: ObjectId {
        set{
            _id = newValue
        }
        get{
            return _id
        }
    }
    
    var type: FieldState {
        if self.id < GameSettings.DOTKUN_NUM/2 {
            return GameObjectType.ALLY
        }else if self.id < GameSettings.DOTKUN_NUM {
            return GameObjectType.ENEMY
        } else if self.id <= GameSettings.DOTKUN_NUM+1 {
            return GameObjectType.ALLY
        } else if self.id <= GameSettings.DOTKUN_NUM+2 {
            return GameObjectType.ENEMY
        } else {
            return GameObjectType.NONE
        }
    }
    
    private var _hp: Int = 0
    var hp: Int {
        set {
            _hp = newValue
        }
        get {
            return _hp
        }
    }
    
    var power: Int = 0
    var speed: Int = 0
    var direction = Direction.UP
    
    func isAlive() -> Bool {
        return self.hp > 0
    }
    
    var fieldPosition = Position(x: 0, y: 0)
    func getPosition() -> Position {
        return self.fieldPosition
    }
    
    func setPosition(x: Int, y: Int) {
        self.fieldPosition = Position(x: x, y: y)
    }
    func setPosition(pos: Position) {
        self.fieldPosition = pos
    }
    
    
    var targetPosition: Position? = nil
    
}