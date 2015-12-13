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
        return Position(x: Int(screenPoint.x / GameSettings.DOT_SIZE), y: Int(screenPoint.y / GameSettings.DOT_SIZE))
    }
    static func GetTargetDirection(dotkunPos: Position, targetPos: Position) -> Direction {
        let difX = targetPos.x - dotkunPos.x
        let difY = targetPos.y - dotkunPos.y
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
    // GameViewの位置、サイズ
    static let GANE_VIEW_X_OFFSET: CGFloat = 10
    static let GAME_VIEW_Y_OFFSET: CGFloat = 20
    static let GAME_VIEW_WIDTH: CGFloat = UIScreen.mainScreen().bounds.size.width - 2 * GameSettings.GANE_VIEW_X_OFFSET
    static let GAME_VIEW_HEIGHT: CGFloat = GameSettings.DOT_SIZE * CGFloat(GameSettings.FIELD_HEIGHT)
    
    static let BATTLEICON_WIDTH: Int = 16
    static let BATTLEICON_HEIGHT: Int = 16
    static let INITIAL_DOT_X_OFFSET: Int = 14 //44
    static let INITIAL_DOT_Y_OFFSET: Int = 10 //45

    static let FIELD_WIDTH: Int = 60 //120
    static let FIELD_HEIGHT: Int = 100 //200
    static let DOT_SIZE: CGFloat = GameSettings.GAME_VIEW_WIDTH / CGFloat(GameSettings.FIELD_WIDTH) //6 //3
    static let DOTKUN_NUM: Int = GameSettings.BATTLEICON_WIDTH * GameSettings.BATTLEICON_HEIGHT * 2
    static let CASTLE_SIZE: Int = 10
    
    static let TOUCHCIRCLE_GROWTH_RATE: CGFloat = 5.0
    
    
}

struct FieldCell {
    var state: FieldState {
        if let gameObject = self.gameObject {
            return gameObject.type
        } else {
            return GameObjectType.NONE
        }
    }
    var gameObject: GameObject? = nil
}

func + (p1:Position, p2:Position)->Position {
    return Position(x: p1.x + p2.x, y: p1.y + p2.y)
}

func += (inout p1:Position, p2:Position){
    p1 = p1 + p2
}

func == (p1: Position, p2: Position)->Bool {
    return p1.x == p2.x && p1.y == p2.y
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
    
    func getPositionValue() -> Position {
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
enum FieldState {
    case NONE
    case ALLY
    case ENEMY
    case OUT_OF_FIELD
}

typealias GameObjectType = FieldState

typealias ObjectId = Int
extension ObjectId {
    static var AllyCastleId: Int {
        return GameSettings.DOTKUN_NUM + 1
    }
    static var EnemyCastleId: Int {
        return GameSettings.DOTKUN_NUM + 2
    }
}