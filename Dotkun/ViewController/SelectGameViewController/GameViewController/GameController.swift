//
//  GameController.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/05.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

struct GameSettings {
    static let FIELD_WIDTH: Int = 80
    static let FIELD_HEIGHT: Int = 120
    static let DOT_SIZE: Int = 6
}

enum FieldState{
    case NONE
    case ALLY
    case ENEMY
}

class GameController {
    
    //private var gameFeild = [[Dotkun?]](count: GameSettings.FIELD_WIDTH, repeatedValue: [Dotkun?](count: GameSettings.FIELD_HEIGHT, repeatedValue: nil))
    private var gameFeild = [[FieldState]](count: GameSettings.FIELD_WIDTH, repeatedValue: [FieldState](count: GameSettings.FIELD_HEIGHT, repeatedValue: FieldState.NONE))
    
    func update(){
        /*TODO
        各Dotkunの状態をupdateする
        */
        
        for x in 0...(GameSettings.FIELD_WIDTH - 1) {
            for y in 0...(GameSettings.FIELD_HEIGHT - 1) {
                if gameFeild[x][y] != FieldState.NONE {
                    
                }
            }
        }
    }
    
    func setDotkun(newDotkun: Dotkun, index: Int){
        /*TODO
        indexによってdotkunの場所の初期化を行う
        */
        gameFeild[index % (GameSettings.FIELD_WIDTH)][index / (GameSettings.FIELD_HEIGHT)] = newDotkun
    }
    
    
    
    
}
