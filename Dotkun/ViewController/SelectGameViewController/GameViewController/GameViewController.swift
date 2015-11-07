//
//  GameViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController {
    
    var updateTimer: NSTimer! = nil
    var gameView: GameView! = nil
    var gameController: GameController! = nil
    var startButton: UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if gameView == nil {
            gameView = GameView(frame: CGRectMake(0,Util.getStatusBarHeight(),self.view.bounds.width, self.view.bounds.height-Util.getStatusBarHeight()))
            gameView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(gameView)
        }
        
        if updateTimer == nil {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval((1.0/Constants.GAME_FPS), target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        }
        
        if gameController == nil {
            gameController = GameController();
        }
        gameController.initGame(gameView)
        
        if startButton == nil {
            startButton = UIButton(frame: CGRectMake(50,300,200,50))
            startButton.setTitle("StartGame", forState: .Normal)
            startButton.addTarget(self, action: "startGame", forControlEvents: .TouchUpInside)
            startButton.backgroundColor = Constants.BACKCOLOR
            self.view.addSubview(startButton)
        }
    }
    
    func onUpdate() {
        gameController.update()
        gameView.setNeedsDisplay()
        startButton.setNeedsDisplay()
    }
    
    func startGame(){
        startButton.removeFromSuperview()
        gameController.startGame()
    }
}
