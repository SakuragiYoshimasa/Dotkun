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
    var gameView: GameView! = nil
    var gameController: GameController! = nil
    var startButton: UIButton! = nil
    var finishTitle: UILabel! = nil
    var touchFlag: Bool = false
    var touchCircle: TouchCircle! = nil
    var dismissButton: UIButton! = nil
    
    //----------------------------------------------------------------
    //Life Cycle
    //----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.GAME_FRAME_COLOR
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishGame", name: "FinishGame", object: nil)
        if gameView == nil {
            gameView = GameView(frame: CGRectMake(GameSettings.GANE_VIEW_X_OFFSET,Util.getStatusBarHeight(),GameSettings.GAME_VIEW_WIDTH, GameSettings.GAME_VIEW_HEIGHT))
            gameView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(gameView)
        }
        if updateTimer == nil {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval((1.0/Constants.GAME_FPS), target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        }
        if gameController == nil {
            gameController = GameController();
            gameController.initGame(gameView)
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
        if finishTitle == nil {
            finishTitle = UILabel(frame: CGRectMake(50,300,200,50))
            finishTitle.text = "Finish Game!"
            finishTitle.backgroundColor = Constants.BACKCOLOR
        }
        if touchCircle == nil {
            touchCircle = TouchCircle()
            gameView.addObject(touchCircle)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //----------------------------------------------------------------
    //Game Cycle
    //----------------------------------------------------------------
    func startGame(){
        startButton.removeFromSuperview()
        finishTitle.removeFromSuperview()
        gameController.startGame()
    }
    
    func onUpdate() {
        //let start = NSDate()
        gameController.update()
        gameView.setNeedsDisplay()
        if touchFlag {
            touchCircle.incrementRadius()
        }
        //let elapsed = NSDate().timeIntervalSinceDate(start)
        //print(elapsed)
    }
    
    func finishGame(){
        self.view.addSubview(finishTitle)
    }
    
    //---------------------------------------------------------------
    //Touch Event
    //---------------------------------------------------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        startMakeCircle(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first?.locationInView(self.view) {
            touchCircle.setPosition(CGPoint(x: touch.x - gameView.frame.minX , y: touch.y - gameView.frame.minY))
        } else {
            touchFlag = false
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        endMakeCircle(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let unwrappedTouches = touches {
            endMakeCircle(unwrappedTouches, withEvent: event)
        }
    }
    
    func startMakeCircle(touches: Set<UITouch>, withEvent event: UIEvent?){
        if gameController.gameState == .START {
            return
        }
        if let touch = touches.first?.locationInView(self.view) {
            touchCircle.setPosition(CGPoint(x: touch.x - gameView.frame.minX , y: touch.y - gameView.frame.minY))
            touchFlag = true
            touchCircle.isVisible = true
        }
    }
    
    func endMakeCircle(touches: Set<UITouch>, withEvent event: UIEvent?){
        if gameController.gameState == .START {
            return
        }
        if let touch = touches.first?.locationInView(self.view) {
            touchCircle.setPosition(CGPoint(x: touch.x - gameView.frame.minX , y: touch.y - gameView.frame.minY))
            touchFlag = false
            gameController.assembleDotkuns(touchCircle.getTouchInfo())
            touchCircle.reset()
            touchCircle.isVisible = false
        }
    }
}
