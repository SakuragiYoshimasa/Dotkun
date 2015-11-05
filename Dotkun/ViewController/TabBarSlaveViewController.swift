//
//  TabBarSlaveViewController.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/04.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

protocol TabBarMasterDelegate {
    func getTabBarHeight() -> CGFloat
    func receiveMessage(message: Constants.Message)
}

class TabBarSlaveViewController: BaseViewController {
    private final var master: TabBarMasterDelegate! = nil
    
    final func sendMesasgeToMaster(message: Constants.Message){
        if self.master != nil {
            self.master.receiveMessage(message)
        }
    }
    
    final func getTabBarHeight() -> CGFloat {
        return master.getTabBarHeight()
    }
    
    final func setMaster(master: TabBarMasterDelegate){
        self.master = master
    }
}