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
    
    func checkAlive() -> Bool {
        return self.hp > 0
    }
    
    func getPosition() -> Position {
        if fieldPosition == nil {
            fieldPosition = Position(x:0, y:0)
        }
        return self.fieldPosition
    }
    
    var targetPosition: Position! = nil
    var fieldPosition: Position! = nil
}