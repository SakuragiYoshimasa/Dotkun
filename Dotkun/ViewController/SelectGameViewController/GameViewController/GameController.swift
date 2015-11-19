//
//  GameController.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/05.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//
import Foundation
import UIKit

class GameController {
    
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    private var gameFeild = [[FieldCell]](count: GameSettings.FIELD_WIDTH, repeatedValue: [FieldCell](count: GameSettings.FIELD_HEIGHT, repeatedValue: FieldCell(state: FieldState.NONE, gameObject: nil)))
    var dotkuns: [Dotkun] = []
    var castles: [Castle] = []
    var frameCounter: Int = 0
    var gameState:GameState = GameState.START
    
    //----------------------------------------------------------------
    //Game Cycle
    //----------------------------------------------------------------
    func initGame(gameView: GameView){
        initCastle(gameView)
        dotkuns = []
        
        let allyImage:UIImage = ModelManager.manager.currentBattleIcon?.image?.getResizedImage(CGSizeMake(CGFloat(GameSettings.BATTLEICON_WIDTH),CGFloat(GameSettings.BATTLEICON_HEIGHT))) ?? UIImage(named: "ha1f.png")!
        let enemyImage: UIImage = UIImage(named: "ha1f.png")!
        
        var i = 0
        // 自軍
        for _ in 0..<(GameSettings.DOTKUN_NUM/2) {
            let dotkun = Dotkun(color: allyImage.getColor(CGPoint(
                x: i % GameSettings.BATTLEICON_WIDTH,
                y: i / GameSettings.BATTLEICON_HEIGHT)),
                id: i)
            setDotkunToFieldCell(dotkun)
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
            i++
        }
        
        // 敵軍
        for _ in 0..<(GameSettings.DOTKUN_NUM/2) {
            let dotkun = Dotkun(color: enemyImage.getColor(CGPoint(
                x: GameSettings.BATTLEICON_WIDTH - ((i - GameSettings.DOTKUN_NUM/2) % GameSettings.BATTLEICON_WIDTH) - 1,
                y: GameSettings.BATTLEICON_HEIGHT - ((i - GameSettings.DOTKUN_NUM/2) / GameSettings.BATTLEICON_HEIGHT) - 1)
                ), id: i)
            setDotkunToFieldCell(dotkun)
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
            i++
        }
    }
    
    func update(){
        switch gameState {
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
                initFieldCell(castle.getPosition())
                castle.isVisible = false
                NSNotificationCenter.defaultCenter().postNotificationName("FinishGame", object: nil)
                continue
            }
        }
        for dotkun in dotkuns {
            if !dotkun.isVisible {continue}
            if !dotkun.checkAlive() {
                initFieldCell(dotkun.getPosition())
                dotkun.isVisible = false
                continue
            }
            if !dotkun.isActionFrame(frameCounter) {continue}
            dotkun.updateDirection()
            let nextPosition: Position = dotkun.getPosition() + dotkun.getDirection().getPositionValue()
            let fieldState: FieldState = checkField(nextPosition)
            switch fieldState {
            case .ALLY, .ENEMY:
                if dotkun.id.getObjectType() == fieldState {
                    dotkun.changeDirection()
                }else{
                    dotkun.battleWith(getGameViewObject(nextPosition))
                }
                break
            case .NONE:
                initFieldCell(dotkun.getPosition())
                dotkun.updatePosition()
                setDotkunToFieldCell(dotkun)
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
    func initCastle(gameView: GameView){
        castles = []
        let allyCastle = Castle(color: Constants.BACKCOLOR, pos: TestUtil.randomPoint(gameView.bounds), id: ObjectId.AllyCastleId)
        let enemyCastle = Castle(color: Constants.BACKCOLOR, pos: TestUtil.randomPoint(gameView.bounds), id: ObjectId.EnemyCastleId)
        allyCastle.updatePosition(GameSettings.FIELD_WIDTH - GameSettings.CASTLE_SIZE, y: GameSettings.FIELD_HEIGHT - GameSettings.CASTLE_SIZE);
        enemyCastle.updatePosition(0, y: 0)
        for x in 0..<GameSettings.CASTLE_SIZE {
            for y in 0..<GameSettings.CASTLE_SIZE {
                gameFeild[GameSettings.FIELD_WIDTH - 1 - x][GameSettings.FIELD_HEIGHT - 1 - y].state = FieldState.ALLY
                gameFeild[GameSettings.FIELD_WIDTH - 1 - x][GameSettings.FIELD_HEIGHT - 1 - y].gameObject = allyCastle
                gameFeild[x][y].state = FieldState.ENEMY
                gameFeild[x][y].gameObject = enemyCastle
            }
        }
        castles.append(allyCastle)
        castles.append(enemyCastle)
        gameView.addObject(allyCastle)
        gameView.addObject(enemyCastle)
    }
    
    //-------------------------------------------------
    //セル操作
    //-------------------------------------------------
    func initFieldCell(position: Position){
        gameFeild[position.x][position.y].state = FieldState.NONE
        gameFeild[position.x][position.y].gameObject = nil
    }
    
    func setDotkunToFieldCell(dotkun: Dotkun){
        gameFeild[dotkun.getPosition().x][dotkun.getPosition().y].gameObject = dotkun
        gameFeild[dotkun.getPosition().x][dotkun.getPosition().y].state = dotkun.id.getObjectType()
    }
    
    func checkField(position:Position)->FieldState{
        if(position.x >= GameSettings.FIELD_WIDTH || position.x < 0 || position.y >= GameSettings.FIELD_HEIGHT || position.y < 0) {
            return .OUT_OF_FIELD
        }
        return gameFeild[position.x][position.y].state
    }
    
    func getGameViewObject(position: Position)->GameViewObject{
        return gameFeild[position.x][position.y].gameObject!
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
        for x in (-radius)...(radius) {
            for y in (-abs(radius - abs(x)))...(abs(radius - abs(x))) {
                if x + center.x < 0 || x + center.x >= GameSettings.FIELD_WIDTH || y + center.y < 0 || y + center.y >= GameSettings.FIELD_HEIGHT { continue }
                if let dotkun = gameFeild[x + center.x][y + center.y].gameObject {
                    if dotkun.id.getObjectType() == GameObjectType.ALLY {
                        dotkun.targetPosition = center
                    }
                }
            }
        }
    }
}