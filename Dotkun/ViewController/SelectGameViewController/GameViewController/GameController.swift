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
    private let width: Int
    private let height: Int
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        field = [[FieldCell]](count: width, repeatedValue: [FieldCell](count: height, repeatedValue: FieldCell()))
    }
    
    func isValidPosition(x: Int, _ y: Int) -> Bool {
        if(x >= width || x < 0 || y >= height || y < 0) {
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
    
    func move(gameObject: GameObject) {
        self.clearCell(gameObject.fieldPosition)
        gameObject.updatePosition()
        self.setGameObject(gameObject.fieldPosition, object: gameObject)
    }
}

class GameController {
    
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private let gameFeild = GameField(width: GameSettings.FIELD_WIDTH, height: GameSettings.FIELD_HEIGHT)
    
    var dotkuns: [Dotkun] = []
    
    var allyCastle: Castle! = nil
    var enemyCastle: Castle! = nil
    var castles: [Castle] {
        return [allyCastle, enemyCastle]
    }
    var frameCounter: Int = 0
    var gameState = GameState.START
    
    var touchingFlag: Bool = false
    var touchCircle: TouchCircle! = nil
    
    //----------------------------------------------------------------
    //Game Cycle
    //----------------------------------------------------------------
    func initGame() -> [GameViewObject] {
        initCastles()
        initDotkuns()
        touchCircle = TouchCircle()
        
        gameState = GameState.START
        
        return (dotkuns as [GameViewObject]) + (castles as [GameViewObject]) + ([touchCircle] as [GameViewObject])
    }
    
    static func reversedPosition(pos: Position, width: Int, height: Int) -> Position {
        return Position(x: width - 1 - pos.x, y: height - 1 - pos.y)
    }
    
    func reversePosition(pos: Position) -> Position {
        return GameController.reversedPosition(pos, width: GameSettings.FIELD_WIDTH, height: GameSettings.FIELD_HEIGHT)
    }
    
    func initDotkuns() {
        self.dotkuns = []
        
        let battleIconSize = CGSizeMake(CGFloat(GameSettings.BATTLEICON_WIDTH), CGFloat(GameSettings.BATTLEICON_HEIGHT))
        
        let allyImage = (ModelManager.manager.currentBattleIcon?.image ??  UIImage(named: "ha1f.png")!)
            .getResizedImage(battleIconSize)
            .getFlatImage()
        
        let enemyImage = UIImage(named: "ha1f.png")!
            .getResizedImage(battleIconSize)
            .getFlatImage()
        
        // 自軍
        for i in 0..<(GameSettings.DOTKUN_NUM/2) {
            let xPos = i % GameSettings.BATTLEICON_WIDTH
            let yPos = i / GameSettings.BATTLEICON_HEIGHT
            
            let dotkunColor = allyImage.getColor(x: xPos, y: yPos)
            let dotkun = Dotkun(
                color: dotkunColor,
                id: i,
                pos: Position(x: xPos - GameSettings.BATTLEICON_WIDTH + 1, y: yPos - GameSettings.BATTLEICON_HEIGHT + 1)
                    + reversePosition(GameSettings.INITIAL_BATTLEICON_OFFSET)
            )
            gameFeild.setGameObject(dotkun.fieldPosition, object: dotkun)
            dotkuns.append(dotkun)
            dotkun.setDirection(Direction.UP)
        }
        
        // 敵軍
        for i in (0..<(GameSettings.DOTKUN_NUM/2)).reverse() {
            let xPos = i % GameSettings.BATTLEICON_WIDTH
            let yPos = i / GameSettings.BATTLEICON_HEIGHT
            
            let dotkun = Dotkun(
                color: enemyImage.getColor(x: xPos, y: yPos),
                id: i + GameSettings.DOTKUN_NUM/2,
                pos: GameController.reversedPosition(Position(x: xPos, y: yPos), width: GameSettings.BATTLEICON_WIDTH, height: GameSettings.BATTLEICON_HEIGHT)
                    + GameSettings.INITIAL_BATTLEICON_OFFSET
            )
            gameFeild.setGameObject(dotkun.fieldPosition, object: dotkun)
            dotkuns.append(dotkun)
            dotkun.setDirection(Direction.DOWN)
        }
        
        aliveDotkuns = dotkuns.filter({$0.isVisible})
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
    var aliveDotkuns: [Dotkun] = []
    func updateGameState() {
        for castle in castles {
            // 城がどっちか死んでたら処理しない
            guard castle.isVisible else {
                return
            }
            
            if !checkAlive(castle) {
                NSNotificationCenter.defaultCenter().postNotificationName("FinishGame", object: nil)
                break
            }
        }
        
        aliveDotkuns = aliveDotkuns.filter({$0.isVisible})
        
        // 移動フェーズ
        aliveDotkuns.forEach() { dotkun in
            guard dotkun.isActionFrame(frameCounter) else { return }
            
            // targetに基いてdirectionを設定
            updateDotkunDirection(dotkun)
            
            let nextPositionState = gameFeild.getState(dotkun.fieldPosition.advancedBy(dotkun.getDirection()))
            if nextPositionState == dotkun.type {
                dotkun.changeDirection()
            } else if nextPositionState == .NONE {
                // 普通に移動
                gameFeild.move(dotkun)
            } else {
                // out of field
                dotkun.changeDirection()
            }
        }
        
        // 攻撃フェーズ
        aliveDotkuns.filter({$0.type == .ALLY}).forEach(battleIfNeed)
        battleIfNeed(allyCastle)
        
        print(allyCastle.hp)
        
        // 生死判定フェーズ、死んでたらisVisible = false
        aliveDotkuns.forEach {[unowned self] dotkun in
            self.checkAlive(dotkun)
        }
        frameCounter++
    }
    
    func checkAlive(o: GameObject) -> Bool {
        if o.isAlive {
            return true
        } else {
            gameFeild.clearCell(o.getPosition())
            o.isVisible = false
            return false
        }
    }
    
    func battle(o1: GameObject, _ o2: GameObject) {
        o2.hp -= o1.power
        o1.hp -= o2.power
    }
    
    func battleIfNeed(o: GameObject) {
        guard o.isActionFrame(frameCounter) else { return }
        for i in 0..<4 {
            if let o2 = self.gameFeild.getGameObject(o.fieldPosition.advancedBy(Direction(rawValue: i)!)) {
                if o2.type != o.type {
                    battle(o, o2)
                }
            }
        }
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
            if self.gameFeild.getState(dotkun.fieldPosition.advancedBy(res)) != FieldState.NONE {
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
        allyCastle = Castle(
            color: Constants.BACKCOLOR,
            pos: Position(x: GameSettings.FIELD_WIDTH - GameSettings.CASTLE_SIZE, y: GameSettings.FIELD_HEIGHT - GameSettings.CASTLE_SIZE),
            id: ObjectId.AllyCastleId
        )
        enemyCastle = Castle(
            color: Constants.BACKCOLOR,
            pos: Position(x: 0,y: 0),
            id: ObjectId.EnemyCastleId
        )
        
        // castle領域を埋める
        for x in 0..<GameSettings.CASTLE_SIZE {
            for y in 0..<GameSettings.CASTLE_SIZE {
                gameFeild.setGameObject(Position(x: GameSettings.FIELD_WIDTH - 1 - x, y: GameSettings.FIELD_HEIGHT - 1 - y), object: allyCastle)
                gameFeild.setGameObject(Position(x: x, y: y), object: enemyCastle)
            }
        }
    }

    //------------------------------------------------
    //イベント
    //------------------------------------------------
    func startGame(){
        gameState = GameState.GAME
    }
    
    // 円形領域でDotkunを集める
    func assembleDotkuns(touchInfo: TouchInfo) {
        let center = GameUtils.TransScreenToGameFieldPosition(touchInfo.touchPosition)
        let radius = Int(touchInfo.touchRadius/CGFloat(GameSettings.DOT_SIZE))
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
    
    func moveCircle(center: CGPoint) {
        touchCircle.setPosition(center)
    }
    
    func startMakeCircle(center: CGPoint, withEvent event: UIEvent?){
        guard gameState == GameState.GAME else {
            return
        }
        touchCircle.setPosition(center)
        touchingFlag = true
        touchCircle.isVisible = true
    }
    
    func endMakeCircle(center: CGPoint, withEvent event: UIEvent?){
        guard gameState == GameState.GAME else {
            return
        }
        touchCircle.setPosition(center)
        touchingFlag = false
        assembleDotkuns(touchCircle.getTouchInfo())
        touchCircle.reset()
        touchCircle.isVisible = false
    }
}