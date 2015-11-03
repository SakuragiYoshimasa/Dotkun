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
    
    var dotkuns: [Dotkun] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if gameView == nil {
            gameView = GameView(frame: CGRectMake(0,Util.getStatusBarHeight(),self.view.bounds.width, self.view.bounds.height-Util.getStatusBarHeight()))
            self.view.addSubview(gameView)
        }
        
        if updateTimer == nil {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval((1.0/Constants.GAME_FPS), target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        }
        
        initGame()
    }
    
    func initGame() {
        dotkuns = []
        for _ in 0...1023 {
            let dotkun = Dotkun(color: TestUtil.randomColor(), pos: TestUtil.randomPoint(gameView.bounds))
            dotkuns.append(dotkun)
            gameView.addObject(dotkun)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onUpdate() {
        gameView.setNeedsDisplay()
        for dotkun in dotkuns {
            dotkun.move(Util.generateRandom()*2-1, y: Util.generateRandom()*2-1)
        }
        print("update")
    }
    
}
