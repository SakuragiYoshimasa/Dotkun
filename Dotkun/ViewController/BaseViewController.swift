//
//  BaseViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var statusBarView: UIView! = nil
    
    override func viewDidLoad() {
        self.view.backgroundColor = Constants.BACKCOLOR
        
        if statusBarView == nil {
            let statusBarHeight = Util.getStatusBarHeight()
            self.statusBarView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, statusBarHeight))
            self.statusBarView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(self.statusBarView)
        }
    }
    
}