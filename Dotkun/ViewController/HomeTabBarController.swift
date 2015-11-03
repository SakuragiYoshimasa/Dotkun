//
//  HomeTabBarController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

protocol SegueFromMasterDelegate {
    func performSegue(identifier: String)
    func getTabBarHeight() -> CGFloat
}

class HomeTabBarController: UITabBarController, SegueFromMasterDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var viewControllers: [UIViewController] = []
        
        let firstViewController = SelectGameViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 1)
        firstViewController.masterViewController = self
        viewControllers.append(firstViewController)
        
        let secondViewController = AccountViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.MostViewed, tag: 2)
        secondViewController.masterViewController = self
        viewControllers.append(secondViewController)
        
        /*let thirdViewController = ThirdViewController()
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 3)
        viewControllers.append(thirdViewController)*/
        
        self.setViewControllers(viewControllers, animated: false)
        
        
        // なぜか0だけだと選択されないので1にしてから0に
        self.selectedIndex = 1
        self.selectedIndex = 0
    }
    
    func getTabBarHeight() -> CGFloat {
        print(self.tabBar.frame.height)
        return self.tabBar.frame.height
    }
    
    func performSegue(identifier: String) {
        startGame()
    }
    
    func startGame() {
        self.performSegueWithIdentifier("startGame", sender: nil)
    }
}
