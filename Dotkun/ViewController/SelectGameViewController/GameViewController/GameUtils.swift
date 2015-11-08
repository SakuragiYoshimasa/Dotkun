//
//  GameUtils.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/05.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//
class GameUtils {
    
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

typealias ObjectId = Int
extension ObjectId {
    func getObjectType()->FieldState {
        if self < GameSettings.DOTKUN_NUM/2 {
            return FieldState.ALLY
        }else if self < GameSettings.DOTKUN_NUM {
            return FieldState.ENEMY
        }/*else if self < GameSettings.DOTKUN_NUM + 1 {
            return FieldState.ALLY_CASTLE
        }else if self < GameSettings.DOTKUN_NUM + 2 {
            return FieldState.ENEMY_CASTLE
        }*/
        return FieldState.NONE
    }
    
    static var AllyCastleId: Int {
        return GameSettings.DOTKUN_NUM + 1
    }
    static var EnemyCastleId: Int {
        return GameSettings.DOTKUN_NUM + 2
    }
}
