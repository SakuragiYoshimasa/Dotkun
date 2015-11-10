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
    var finishTitle: UILabel! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishGame", name: "FinishGame", object: nil)
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
        gameController.initGame(gameView, gvc: self)
        
        if startButton == nil {
            startButton = UIButton(frame: CGRectMake(50,300,200,50))
            startButton.setTitle("StartGame", forState: .Normal)
            startButton.addTarget(self, action: "startGame", forControlEvents: .TouchUpInside)
            startButton.backgroundColor = Constants.BACKCOLOR
            self.view.addSubview(startButton)
        }
        if finishTitle == nil {
            finishTitle = UILabel(frame: CGRectMake(50,300,200,50))
            finishTitle.text = "Finish Game!"
            finishTitle.backgroundColor = Constants.BACKCOLOR
        }
  
    }
    
    func onUpdate() {
        gameController.update()
        gameView.setNeedsDisplay()
    }
    
    func startGame(){
        startButton.removeFromSuperview()
        gameController.startGame()
    }
    
    func finishGame(){
        self.view.addSubview(finishTitle)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first?.locationInView(self.view)
        //updateColor(colorsView.colorFromPoint(touch!))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first?.locationInView(self.view)
       // updateColor(colorsView.colorFromPoint(touch!))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first?.locationInView(self.view)
        //updateColor(colorsView.colorFromPoint(touch!))
        
        //closeView()
    }
}
