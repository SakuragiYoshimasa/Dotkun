//
//  HomeTabBarController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController, TabBarMasterDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var viewControllers: [UIViewController] = []
        
        let firstViewController = SelectGameViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Favorites, tag: 1)
        firstViewController.setMaster(self)
        viewControllers.append(firstViewController)
        
        let secondViewController = BattleIconCollectionViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.More, tag: 2)
        secondViewController.setMaster(self)
        viewControllers.append(secondViewController)
        
        let thirdViewController = ProfileViewController()
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 3)
        thirdViewController.setMaster(self)
        viewControllers.append(thirdViewController)
        
        
        self.setViewControllers(viewControllers, animated: false)
        
        
        // なぜか0だけだと選択されないので1にしてから0に
        self.selectedIndex = 1
        self.selectedIndex = 0
        
        print("loaded")
    }
    
    /**
     - returns: タブの高さ
     */
    func getTabBarHeight() -> CGFloat {
        return self.tabBar.frame.height
    }
    

    func receiveMessage(message: Constants.Message) {
        switch message {
            case .CreateIcon:
                createIcon()
            case .StartGame:
                startGame()
        }
    }
    
    func createIcon() {
        self.performSegueWithIdentifier("createIcon", sender: nil)
    }
    
    func startGame() {
        self.performSegueWithIdentifier("startGame", sender: nil)
    }
}
