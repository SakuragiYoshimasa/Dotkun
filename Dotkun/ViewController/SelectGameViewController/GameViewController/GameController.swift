//
//  GameController.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/05.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//
import Foundation
import UIKit

class GameField {
    private var field: [[FieldCell]]
    init() {
        field = [[FieldCell]](count: GameSettings.FIELD_WIDTH, repeatedValue: [FieldCell](count: GameSettings.FIELD_HEIGHT, repeatedValue: FieldCell()))
    }
    
    func isValidPosition(x: Int, _ y: Int) -> Bool {
        if(x >= GameSettings.FIELD_WIDTH || x < 0 || y >= GameSettings.FIELD_HEIGHT || y < 0) {
            return false
        } else {
            return true
        }
    }
    
    func getState(position: Position) -> FieldState {
        if isValidPosition(position.x, position.y) {
            return self.field[position.x][position.y].state
        } else {
            return .OUT_OF_FIELD
        }
    }
    
    func getGameObject(position: Position) -> GameObject? {
        guard isValidPosition(position.x, position.y) else {
            return nil
        }
        return self.field[position.x][position.y].gameObject
    }
    func getGameObject(x: Int, y: Int) -> GameObject? {
        guard isValidPosition(x, y) else {
            return nil
        }
        return self.field[x][y].gameObject
    }
    
    func setGameObject(position: Position, object: GameObject) {
        guard isValidPosition(position.x, position.y) else {
            return
        }
        self.field[position.x][position.y].gameObject = object
    }
    
    func clearCell(position: Position) {
        guard isValidPosition(position.x, position.y) else {
            return
        }
        self.field[position.x][position.y].gameObject = nil
    }
}

class GameController {
    
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private let gameFeild = GameField()
    private weak var gameView: GameView! = nil
    var dotkuns: [Dotkun] = []
    var castles: [Castle] = []
    var frameCounter: Int = 0
    var gameState = GameState.START
    
    //----------------------------------------------------------------
    //Game Cycle
    //----------------------------------------------------------------
    func initGame(gameView: GameView) {
        self.gameView = gameView
        self.gameView.clear()
        
        initCastles()
        initDotkuns()
        
        gameState = GameState.START
    }
    
    func initDotkuns() {
        self.dotkuns = []
        
        let allyImage = (ModelManager.manager.currentBattleIcon?.image ??  UIImage(named: "ha1f.png")!)
            .getResizedImage(CGSizeMake(CGFloat(GameSettings.BATTLEICON_WIDTH),CGFloat(GameSettings.BATTLEICON_HEIGHT)))
            .getFlatImage()
        let enemyImage = UIImage(named: "ha1f.png")!
            .getResizedImage(CGSizeMake(CGFloat(GameSettings.BATTLEICON_WIDTH),CGFloat(GameSettings.BATTLEICON_HEIGHT)))
            .getFlatImage()
        
        // 自軍
        for i in 0..<(GameSettings.DOTKUN_NUM/2) {
            let dotkunColor = allyImage.getColor(CGPoint(x: i % GameSettings.BATTLEICON_WIDTH, y: i / GameSettings.BATTLEICON_HEIGHT))
            let dotkun = Dotkun(
                color: dotkunColor,
                id: i,
                pos: Position(x: i % GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_X_OFFSET, y: (i / GameSettings.BATTLEICON_WIDTH) + GameSettings.FIELD_HEIGHT - GameSettings.INITIAL_DOT_Y_OFFSET - GameSettings.BATTLEICON_HEIGHT)
            )
            gameFeild.setGameObject(dotkun.getPosition(), object: dotkun)
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
            dotkun.setDirection(Direction.UP)
        }
        
        // 敵軍
        for i in 0..<(GameSettings.DOTKUN_NUM/2) {
            let dotkun = Dotkun(
                color: enemyImage.getColor(CGPoint(x: GameSettings.BATTLEICON_WIDTH - (i % GameSettings.BATTLEICON_WIDTH) - 1, y: GameSettings.BATTLEICON_HEIGHT - (i / GameSettings.BATTLEICON_HEIGHT) - 1)),
                id: i+GameSettings.DOTKUN_NUM/2,
                pos: Position(x: i % GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_X_OFFSET,
                    y: i/GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_Y_OFFSET)
            )
            gameFeild.setGameObject(dotkun.getPosition(), object: dotkun)
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
            dotkun.setDirection(Direction.DOWN)
        }
    }
    
    func update(){
        switch self.gameState {
        case .START:
            updateStartState()
            break
        case .GAME:
            updateGameState()
            break
        case .FINISH:
            updateFinishState()
            break
        }
    }
    
    func updateStartState() {
    }
    
    // アップデートごとの処理
    func updateGameState() {
        // 城
        for castle in castles {
            // 城がどっちか死んでたら処理しない
            guard castle.isVisible else {
                return
            }
            
            if !castle.checkAlive() {
                gameFeild.clearCell(castle.getPosition())
                castle.isVisible = false
                NSNotificationCenter.defaultCenter().postNotificationName("FinishGame", object: nil)
                continue
            }
        }
        
        let aliveDotkuns = dotkuns.filter({$0.isVisible})
        // 移動フェーズ
        for dotkun in aliveDotkuns {
            guard dotkun.isActionFrame(frameCounter) else { continue }
            
            // targetに基いてdirectionを設定
            updateDotkunDirection(dotkun)
            
            let nextPosition = dotkun.getPosition().advancedBy(dotkun.getDirection())
            switch gameFeild.getState(nextPosition) {
            case .ALLY:
                if dotkun.type == .ALLY {
                    dotkun.changeDirection()
                }
                break
            case .ENEMY:
                if dotkun.type == .ENEMY {
                    dotkun.changeDirection()
                }
                break
            case .NONE:
                // 普通に移動
                gameFeild.clearCell(dotkun.getPosition())
                dotkun.updatePosition()
                gameFeild.setGameObject(dotkun.getPosition(), object: dotkun)
                break
            case .OUT_OF_FIELD:
                dotkun.changeDirection()
                break
            }
        }
        // 攻撃フェーズ
        for dotkun in aliveDotkuns.filter({$0.type == .ALLY}) {
            guard dotkun.isActionFrame(frameCounter) else { continue }
            for i in 0..<4 {
                if let dotkun2 = gameFeild.getGameObject(dotkun.getPosition().advancedBy(Direction(rawValue: i)!)) {
                    if dotkun2.type != dotkun.type {
                        battle(dotkun, dotkun2)
                    }
                }
            }
        }
        // 生死判定フェーズ、死んでたらisVisible = false
        aliveDotkuns.forEach { dotkun in
            if !dotkun.checkAlive() {
                gameFeild.clearCell(dotkun.getPosition())
                dotkun.isVisible = false
            }
        }
        frameCounter++
    }
    
    func battle(o1: GameObject,_ o2: GameObject) {
        o2.hp -= o1.power
        o1.hp -= o2.power
    }
    
    func updateDotkunDirection(dotkun: Dotkun) {
        // targetがないときは維持
        if let targetPos = dotkun.targetPosition {
            
            let difX = targetPos.x - dotkun.getPosition().x
            let difY = targetPos.y - dotkun.getPosition().y
            var res = Direction.RIGHT
            if abs(difX) > abs(difY) {
                if difX >= 0 {
                     res = Direction.RIGHT
                } else {
                    res = Direction.LEFT
                }
            }else{
                if difY >= 0 {
                    res = Direction.DOWN
                } else {
                    res = Direction.UP
                }
            }
            // 雑ながら、移動先がからじゃなかったら修正。どうやったら綺麗にできる？
            if self.gameFeild.getState(dotkun.getPosition().advancedBy(res)) != FieldState.NONE {
                if abs(difX) > abs(difY) {
                    if difY >= 0 {
                        res = Direction.DOWN
                    } else {
                        res = Direction.UP
                    }
                }else{
                    if difX >= 0 {
                        res = Direction.RIGHT
                    } else {
                        res = Direction.LEFT
                    }
                }
            }

            dotkun.setDirection(res)
            if targetPos == dotkun.fieldPosition {
                dotkun.targetPosition = nil
            }
        }
    }
    
    func updateFinishState(){
        
    }
    
    //--------------------------------------------------
    //Manupurate Dotkuns
    //--------------------------------------------------
    func initCastles() {
        // posは左上座標
        let allyCastle = Castle(color: Constants.BACKCOLOR,
            pos: Position(x: GameSettings.FIELD_WIDTH - GameSettings.CASTLE_SIZE, y: GameSettings.FIELD_HEIGHT - GameSettings.CASTLE_SIZE),
            id: ObjectId.AllyCastleId)
        let enemyCastle = Castle(color: Constants.BACKCOLOR,
            pos: Position(x: 0,y: 0),
            id: ObjectId.EnemyCastleId)
        // castle領域を埋める
        for x in 0..<GameSettings.CASTLE_SIZE {
            for y in 0..<GameSettings.CASTLE_SIZE {
                gameFeild.setGameObject(Position(x: GameSettings.FIELD_WIDTH - 1 - x, y: GameSettings.FIELD_HEIGHT - 1 - y), object: allyCastle)
                gameFeild.setGameObject(Position(x: x, y: y), object: enemyCastle)
            }
        }
        self.castles = [allyCastle, enemyCastle]
        self.gameView.addObject(allyCastle)
        self.gameView.addObject(enemyCastle)
    }

    //------------------------------------------------
    //イベント
    //------------------------------------------------
    func startGame(){
        gameState = GameState.GAME
    }
    
    func assembleDotkuns(touchInfo: TouchInfo){
        let center: Position = GameUtils.TransScreenToGameFieldPosition(touchInfo.touchPosition)
        let radius: Int = Int(touchInfo.touchRadius/CGFloat(GameSettings.DOT_SIZE))
        for x in max((center.x - radius), 0)...min((center.x + radius), GameSettings.FIELD_WIDTH-1) {
            let tmp = Int(sqrt(pow(Double(radius), 2) - pow(Double(x-center.x),2)))
            for y in max((center.y-tmp), 0)...min((center.y+tmp), GameSettings.FIELD_HEIGHT-1) {
                if let dotkun = gameFeild.getGameObject(x, y: y) {
                    if dotkun.type == GameObjectType.ALLY {
                        dotkun.targetPosition = center
                    }
                }
            }
        }
    }
}