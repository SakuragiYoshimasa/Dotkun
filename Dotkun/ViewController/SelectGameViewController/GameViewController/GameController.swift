//
//  GameController.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/05.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//
class GameController {
    
    private var gameFeild = [[FieldState]](count: GameSettings.FIELD_WIDTH, repeatedValue: [FieldState](count: GameSettings.FIELD_HEIGHT, repeatedValue: FieldState.NONE))
    var dotkuns: [Dotkun] = []
    
    func update(){
        /*TODO
        各Dotkunの状態をupdateする
        */
        
        for dotkun in dotkuns {
            if checkField(dotkun.getPosition() + dotkun.getDirection().getPositionValue()) {
                
            }
        }
        
        for x in 0..<GameSettings.FIELD_WIDTH {
            for y in 0..<GameSettings.FIELD_HEIGHT {
                if gameFeild[x][y] != FieldState.NONE {
                    
                }
            }
        }
    }
    
    func setDotkun(newDotkun: Dotkun, index: Int){
        /*TODO
        indexによってdotkunの場所の初期化を行う
        */
        //gameFeild[index % (GameSettings.FIELD_WIDTH)][index / (GameSettings.FIELD_HEIGHT)] = newDotkun
    }
    
    func initGame(gameView: GameView){
        dotkuns = []
        for i in 0...2047 {
            let dotkun = Dotkun(color: TestUtil.randomColor(), pos: TestUtil.randomPoint(gameView.bounds))
            dotkun.setIndex(i)
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
            //gameController.setDotkun(dotkun, index: i)
        }
    }
    
    func checkField(position:Position)->Bool{
        return false
    }
    
}
