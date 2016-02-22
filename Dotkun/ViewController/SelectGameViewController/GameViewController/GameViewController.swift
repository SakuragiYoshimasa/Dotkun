//
//  GameViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//
import UIKit

class GameViewController: BaseViewController {
    //----------------------------------------------------------------
    //Variable
    //----------------------------------------------------------------
    var updateTimer: NSTimer! = nil
    var gameView: GameView = GameView(frame: CGRectMake(GameSettings.GANE_VIEW_X_OFFSET,Util.getStatusBarHeight(),GameSettings.GAME_VIEW_WIDTH, GameSettings.GAME_VIEW_HEIGHT))
    var gameController = GameController()
    var startButton: UIButton! = nil
    var finishTitle: UILabel! = nil
    var dismissButton: UIButton! = nil
    
    /*required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init")
    }*/
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.GAME_FRAME_COLOR
        
        gameView.backgroundColor = UIColor.grayColor()
        if !self.view.subviews.contains(gameView) {
            self.view.addSubview(gameView)
        }

        if startButton == nil {
            startButton = UIButton(frame: CGRectMake(50,300,200,50))
            startButton.setTitle("StartGame", forState: .Normal)
            startButton.addTarget(self, action: "startGame", forControlEvents: .TouchUpInside)
            startButton.backgroundColor = Constants.BACKCOLOR
            self.view.addSubview(startButton)
        }
        if dismissButton == nil {
            dismissButton = UIButton(frame: CGRectMake(0,UIScreen.mainScreen().bounds.height - 50,100,50))
            dismissButton.setTitle("Dismiss", forState: .Normal)
            dismissButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
            dismissButton.backgroundColor = Constants.BACKCOLOR
            self.view.addSubview(dismissButton)
        }
        
        gameView.clear()
        let objects = gameController.initGame()
        gameView.addObjects(objects)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishGame", name: "FinishGame", object: nil)
        if updateTimer == nil {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval((1.0/Constants.GAME_FPS), target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        // updateを停止
        updateTimer.invalidate()
        updateTimer = nil
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //----------------------------------------------------------------
    //Game Cycle
    //----------------------------------------------------------------
    func startGame(){
        startButton.removeFromSuperview()
        if let finishTitle = finishTitle {
            if self.view.subviews.contains(finishTitle) {
                finishTitle.removeFromSuperview()
            }
        }
        gameController.startGame()
    }
    
    func onUpdate() {
        gameController.update()
        gameView.setNeedsDisplay()
        if gameController.touchingFlag {
            gameController.touchCircle.incrementRadius()
        }
    }
    
    func finishGame(){
        if finishTitle == nil {
            finishTitle = UILabel(frame: CGRectMake(50,300,200,50))
            finishTitle.text = "Finish Game!"
            finishTitle.backgroundColor = Constants.BACKCOLOR
        }
        self.view.addSubview(finishTitle)
    }
    
    //---------------------------------------------------------------
    //Touch Event
    //---------------------------------------------------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchPos = touches.first?.locationInView(gameView) {
            gameController.startMakeCircle(touchPos, withEvent: event)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchPos = touches.first?.locationInView(gameView) {
            gameController.moveCircle(touchPos)
        } else {
            gameController.touchingFlag = false
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchPos = touches.first?.locationInView(gameView) {
            gameController.endMakeCircle(touchPos, withEvent: event)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touch = touches, let touchPos = touch.first?.locationInView(self.view) {
            gameController.endMakeCircle(touchPos, withEvent: event)
        }
    }
}
