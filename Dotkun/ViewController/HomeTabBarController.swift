//
//  HomeTabBarController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

protocol TabControllerMasterDelegate {
    func performSegue(identifier: String)
    func getTabBarHeight() -> CGFloat
}

class HomeTabBarController: UITabBarController, TabControllerMasterDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var viewControllers: [UIViewController] = []
        
        let firstViewController = SelectGameViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Favorites, tag: 1)
        //firstViewController.masterViewController = self
        firstViewController.setHome(self)
        firstViewController.setIdentifer("startGame")
        viewControllers.append(firstViewController)
        
        let secondViewController = IconCollectionViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.More, tag: 2)
        secondViewController.masterViewController = self
        viewControllers.append(secondViewController)
        
        let thirdViewController = ProfileViewController()
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 3)
        viewControllers.append(thirdViewController)
        
        self.setViewControllers(viewControllers, animated: false)
        
        
        // なぜか0だけだと選択されないので1にしてから0に
        self.selectedIndex = 1
        self.selectedIndex = 0
    }
    
    func getTabBarHeight() -> CGFloat {
        return self.tabBar.frame.height
    }
    
    func performSegue(identifier: String) {
        if identifier == "startGame" {
            startGame()
        } else if identifier == "createIcon" {
            createIcon()
        }
    }
    
    func createIcon() {
        self.performSegueWithIdentifier("createIcon", sender: nil)
    }
    
    func startGame() {
        self.performSegueWithIdentifier("startGame", sender: nil)
    }
}
