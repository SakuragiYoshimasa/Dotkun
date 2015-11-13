//
//  GameUtils.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/05.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//
import UIKit

class GameUtils {
    static func TransScreenToGameFieldPosition(screenPoint: CGPoint) -> Position{
        return Position(x: Int(screenPoint.x) / GameSettings.DOT_SIZE, y: Int(screenPoint.y) / GameSettings.DOT_SIZE)
    }
    static func GetTargetDirection(dotkunPos: Position, targetPos: Position) -> Direction {
        var difX = targetPos.x - dotkunPos.x
        var difY = targetPos.y - dotkunPos.y
        if abs(difX) > abs(difY) {
            if difX >= 0 {
                return Direction.RIGHT
            }else{
                return Direction.LEFT
            }
        }else{
            if difY >= 0 {
                return Direction.DOWN
            }else{
                return Direction.UP
            }
        }
    }
}

struct Position {
    var x: Int
    var y: Int
}

struct GameSettings {
    static let FIELD_WIDTH: Int = 60 //120
    static let FIELD_HEIGHT: Int = 100 //200
    static let DOT_SIZE: Int = 6 //3
    static let DOTKUN_NUM: Int = 2048
    static let CASTLE_SIZE: Int = 10
    static let BATTLEICON_WIDTH: Int = 32
    static let BATTLEICON_HEIGHT: Int = 32
    static let INITIAL_DOT_X_OFFSET: Int = 14 //44
    static let INITIAL_DOT_Y_OFFSET: Int = 10 //45
}

struct FieldCell {
    var state: FieldState
    var gameObject: GameViewObject? = nil
}

func + (p1:Position, p2:Position)->Position {
    return Position(x: p1.x + p2.x, y: p1.y + p2.y)
}

func += (inout p1:Position, p2:Position){
    p1 = p1 + p2
}

func + (p1: CGPoint, p2: CGPoint) -> CGPoint{
    return CGPoint(x: p1.x + p2.x, y: p1.y + p2.y)
}

enum GameState {
    case START
    case GAME
    case FINISH
}

enum Direction : Int {
    case UP = 0
    case RIGHT = 1
    case DOWN = 2
    case LEFT = 3
    
    func getPositionValue()->Position {
        switch self {
        case .UP:
            return Position(x: 0, y: -1);
        case .RIGHT:
            return Position(x: 1, y: 0);
        case .DOWN:
            return Position(x: 0, y: 1);
        case .LEFT:
            return Position(x: -1, y: 0);
        }
    }
}

//ID 0~1023;ALLY 1024~2047::Enemy
enum FieldState{
    case NONE
    case ALLY
    case ENEMY
    case OUT_OF_FIELD
}

typealias GameObjectType = FieldState
typealias ObjectId = Int
extension ObjectId {
    func getObjectType()->GameObjectType {
        if self < GameSettings.DOTKUN_NUM/2 {
            return GameObjectType.ALLY
        }else if self < GameSettings.DOTKUN_NUM {
            return GameObjectType.ENEMY
        }/*else if self < GameSettings.DOTKUN_NUM + 1 {
            return FieldState.ALLY_CASTLE
        }else if self < GameSettings.DOTKUN_NUM + 2 {
            return FieldState.ENEMY_CASTLE
        }*/
        return GameObjectType.NONE
    }
    
    static var AllyCastleId: Int {
        return GameSettings.DOTKUN_NUM + 1
    }
    static var EnemyCastleId: Int {
        return GameSettings.DOTKUN_NUM + 2
    }
}

let pixelDataByteSize = 4

extension UIImage {
    
    func getColor(pos: CGPoint) -> UIColor {
        
        let imageData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data : UnsafePointer = CFDataGetBytePtr(imageData)
        let address : Int = Int(32 * pos.y + pos.x)  * pixelDataByteSize
        let r = CGFloat(data[address])/CGFloat(255.0)
        let g = CGFloat(data[address+1])/CGFloat(255.0)
        let b = CGFloat(data[address+2])/CGFloat(255.0)
        let a = CGFloat(data[address+3])/CGFloat(255.0)
        print(UIColor(red: r, green: g, blue: b, alpha: a))
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}