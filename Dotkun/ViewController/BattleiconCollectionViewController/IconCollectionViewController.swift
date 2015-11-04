//
//  IconCollectionViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//


import UIKit

class IconCollectionViewController: TabBarSlaveViewController {
    
    var createButton: UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if createButton == nil {
            createButton = UIButton(frame: CGRectMake(50,50,200,50))
            createButton.setTitle("createIcon", forState: .Normal)
            createButton.addTarget(self, action: "createIcon", forControlEvents: .TouchUpInside)
            self.view.addSubview(createButton)
        }
    }
    
    func createIcon() {
        self.sendMesasgeToMaster(Constants.Message.CreateIcon)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
