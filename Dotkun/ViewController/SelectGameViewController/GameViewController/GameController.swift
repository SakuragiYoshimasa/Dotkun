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
    
    func getState(position: Position) -> FieldState {
        if(position.x >= GameSettings.FIELD_WIDTH || position.x < 0 || position.y >= GameSettings.FIELD_HEIGHT || position.y < 0) {
            return .OUT_OF_FIELD
        }
        return self.field[position.x][position.y].state
    }
    
    func getGameObject(position: Position) -> GameObject? {
        return self.field[position.x][position.y].gameObject
    }
    func getGameObject(x: Int, y: Int) -> GameObject? {
        return self.field[x][y].gameObject
    }
    
    func setGameObject(position: Position, object: GameObject) {
        self.field[position.x][position.y].gameObject = object
    }
    
    func clearCell(position: Position) {
        self.field[position.x][position.y].gameObject = nil
    }
}

class GameController {
    
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    
    private let gameFeild = GameField()
    var dotkuns: [Dotkun] = []
    var castles: [Castle] = []
    var frameCounter: Int = 0
    var gameState: GameState = GameState.START
    
    //----------------------------------------------------------------
    //Game Cycle
    //----------------------------------------------------------------
    func initGame(gameView: GameView){
        initCastle(gameView)
        dotkuns = []
        
        let allyImage = (ModelManager.manager.currentBattleIcon?.image ??  UIImage(named: "ha1f.png")!).getResizedImage(CGSizeMake(CGFloat(GameSettings.BATTLEICON_WIDTH),CGFloat(GameSettings.BATTLEICON_HEIGHT))).getFlatImage()
        let enemyImage = UIImage(named: "ha1f.png")!.getResizedImage(CGSizeMake(CGFloat(GameSettings.BATTLEICON_WIDTH),CGFloat(GameSettings.BATTLEICON_HEIGHT))).getFlatImage()
        
        // 自軍
        for i in 0..<(GameSettings.DOTKUN_NUM/2) {
            let dotkunColor = allyImage.getColor(CGPoint(x: i % GameSettings.BATTLEICON_WIDTH, y: i / GameSettings.BATTLEICON_HEIGHT))
            let dotkun = Dotkun(color: dotkunColor, id: i)
            gameFeild.setGameObject(dotkun.getPosition(), object: dotkun)
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
            
            dotkun.updatePosition(
                i % GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_X_OFFSET,
                y: (i / GameSettings.BATTLEICON_WIDTH) + GameSettings.FIELD_HEIGHT - GameSettings.INITIAL_DOT_Y_OFFSET - GameSettings.BATTLEICON_HEIGHT
            )
            dotkun.setDirection(Direction.UP)
        }
        
        // 敵軍
        for i in 0..<(GameSettings.DOTKUN_NUM/2) {
            let dotkun = Dotkun(color: enemyImage.getColor(CGPoint(
                x: GameSettings.BATTLEICON_WIDTH - (i % GameSettings.BATTLEICON_WIDTH) - 1,
                y: GameSettings.BATTLEICON_HEIGHT - (i / GameSettings.BATTLEICON_HEIGHT) - 1)
                ), id: i+GameSettings.DOTKUN_NUM/2)
            gameFeild.setGameObject(dotkun.getPosition(), object: dotkun)
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
            
            dotkun.updatePosition(
                (i+GameSettings.DOTKUN_NUM/2) % GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_X_OFFSET,
                y: i/GameSettings.BATTLEICON_WIDTH + GameSettings.INITIAL_DOT_Y_OFFSET
            )
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
    
    func updateStartState(){}
    
    func updateGameState(){
        for castle in castles {
            if !castle.isVisible {return}
            if !castle.checkAlive() {
                gameFeild.clearCell(castle.getPosition())
                castle.isVisible = false
                NSNotificationCenter.defaultCenter().postNotificationName("FinishGame", object: nil)
                continue
            }
        }
        
        for dotkun in dotkuns {
            if !dotkun.isVisible {continue}
            if !dotkun.checkAlive() {
                gameFeild.clearCell(dotkun.getPosition())
                dotkun.isVisible = false
                continue
            }
            if !dotkun.isActionFrame(frameCounter) {continue}
            dotkun.updateDirection()
            let nextPosition: Position = dotkun.getPosition() + dotkun.getDirection().getPositionValue()
            let fieldState: FieldState = checkField(nextPosition)
            switch fieldState {
            case .ALLY, .ENEMY:
                if dotkun.type == fieldState {
                    dotkun.changeDirection()
                } else {
                    if let enemy = gameFeild.getGameObject(nextPosition) {
                        dotkun.battleWith(enemy)
                    }
                }
                break
            case .NONE:
                gameFeild.clearCell(dotkun.getPosition())
                dotkun.updatePosition()
                gameFeild.setGameObject(dotkun.getPosition(), object: dotkun)
                break;
            case .OUT_OF_FIELD:
                dotkun.changeDirection()
                break;
            }
        }
        frameCounter++
    }
    
    func updateFinishState(){
        
    }
    
    //--------------------------------------------------
    //Manupurate Dotkuns
    //--------------------------------------------------
    func initCastle(gameView: GameView) {
        let allyCastle = Castle(color: Constants.BACKCOLOR, pos: CGPoint.zero, id: ObjectId.AllyCastleId)
        let enemyCastle = Castle(color: Constants.BACKCOLOR, pos: CGPoint.zero, id: ObjectId.EnemyCastleId)
        allyCastle.updatePosition(GameSettings.FIELD_WIDTH - GameSettings.CASTLE_SIZE, y: GameSettings.FIELD_HEIGHT - GameSettings.CASTLE_SIZE);
        enemyCastle.updatePosition(0, y: 0)
        for x in 0..<GameSettings.CASTLE_SIZE {
            for y in 0..<GameSettings.CASTLE_SIZE {
                gameFeild.setGameObject(Position(x: GameSettings.FIELD_WIDTH - 1 - x, y: GameSettings.FIELD_HEIGHT - 1 - y), object: allyCastle)
                gameFeild.setGameObject(Position(x: x, y: y), object: enemyCastle)
            }
        }
        self.castles = [allyCastle, enemyCastle]
        gameView.addObject(allyCastle)
        gameView.addObject(enemyCastle)
    }
    
    //-------------------------------------------------
    //セル操作
    //-------------------------------------------------
    func checkField(position:Position) -> FieldState {
        if(position.x >= GameSettings.FIELD_WIDTH || position.x < 0 || position.y >= GameSettings.FIELD_HEIGHT || position.y < 0) {
            return .OUT_OF_FIELD
        }
        return gameFeild.getState(position)
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