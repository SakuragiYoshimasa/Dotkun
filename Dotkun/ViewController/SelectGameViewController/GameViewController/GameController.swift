//
//  GameController.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/05.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//
import Foundation

class GameController {
    
    private var gameFeild = [[FieldCell]](count: GameSettings.FIELD_WIDTH, repeatedValue: [FieldCell](count: GameSettings.FIELD_HEIGHT, repeatedValue: FieldCell(state: FieldState.NONE, dotkun: nil)))
    var dotkuns: [Dotkun] = []
    var frameCounter: Int = 0
    var gameState:GameState = GameState.START
    
    //------------------------------------------------
    //GameCycle
    //------------------------------------------------
    func initGame(gameView: GameView){
        dotkuns = []
        for i in 0..<GameSettings.DOTKUN_NUM {
            let dotkun = Dotkun(color: TestUtil.randomColor(), pos: TestUtil.randomPoint(gameView.bounds))
            dotkun.id = i
            dotkun.updatePosition(i % GameSettings.FIELD_WIDTH, y: i / (GameSettings.FIELD_HEIGHT))
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
            setDotkun(dotkun, ID: i)
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
        for dotkun in dotkuns {
            if dotkun.getSpentFrames() > frameCounter {continue}
            dotkun.updateDirection()
            
            switch checkField(dotkun.getPosition() + dotkun.getDirection().getPositionValue()){
            case .ALLY:
                dotkun.changeDirection()
                dotkun.updateFrame(frameCounter)
                break;
            case .ENEMY:
                battle(dotkun, enemyDotkun: getDotkun(dotkun.getPosition() + dotkun.getDirection().getPositionValue()))
                dotkun.changeDirection()
                break;
            case .NONE:
                initFieldCell(dotkun.getPosition())
                dotkun.updatePosition()
                setDotkunToFieldCell(dotkun)
                dotkun.updateFrame(frameCounter)
                break;
            case .OUT_OF_FIELD:
                dotkun.changeDirection()
                dotkun.updateFrame(frameCounter)
                break;
            }
        }
        frameCounter++
    }
    
    func updateFinishState(){
        
    }
    
    //--------------------------------------------------
    //Dotkun操作
    //--------------------------------------------------
    func setDotkun(newDotkun: Dotkun, ID: Int){
        /*TODO
        indexによってdotkunの場所の初期化を行う
        */
        newDotkun.updatePosition(ID % GameSettings.FIELD_WIDTH, y: ID / (GameSettings.FIELD_HEIGHT))
    }
    
    func battle(allyDotkun: Dotkun, enemyDotkun: Dotkun){
        allyDotkun.updateFrame(frameCounter)
        enemyDotkun.updateFrame(frameCounter)
        allyDotkun.battleWith(enemyDotkun)
    }
    
    //-------------------------------------------------
    //セル操作
    //-------------------------------------------------
    func initFieldCell(position: Position){
        gameFeild[position.x][position.y].state = FieldState.NONE
        gameFeild[position.x][position.y].dotkun = nil
    }
    
    func setDotkunToFieldCell(dotkun: Dotkun){
        gameFeild[dotkun.getPosition().x][dotkun.getPosition().y].dotkun = dotkun
        if dotkun.id < GameSettings.DOTKUN_NUM/2 {
            gameFeild[dotkun.getPosition().x][dotkun.getPosition().y].state = FieldState.ALLY
        }else{
            gameFeild[dotkun.getPosition().x][dotkun.getPosition().y].state = FieldState.ENEMY
        }
    }
    
    func checkField(position:Position)->FieldState{
        if(position.x >= GameSettings.FIELD_WIDTH || position.x < 0 || position.y >= GameSettings.FIELD_HEIGHT || position.y < 0) {
            return .OUT_OF_FIELD
        }
        return gameFeild[position.x][position.y].state
    }
    
    func getDotkun(position: Position)->Dotkun{
        return gameFeild[position.x][position.y].dotkun!
    }
    
    //------------------------------------------------
    //イベント
    //------------------------------------------------
    func startGame(){
        gameState = GameState.GAME
    }
}
