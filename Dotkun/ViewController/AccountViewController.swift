//
//  AccountViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController {
    
    var masterViewController: TabControllerMasterDelegate! = nil
    
    var imageView: UIImageView!
    var namelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if imageView == nil {
            imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(200, 200)))
            imageView.layer.position = CGPointMake(self.view.bounds.midX, 150 + Util.getStatusBarHeight())
            self.view.addSubview(imageView)
        }
        
        if namelabel == nil {
            namelabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSizeMake(300, 50)))
            namelabel.layer.position = CGPointMake(self.view.bounds.midX, 150 + Util.getStatusBarHeight()+120)
            namelabel.textAlignment = NSTextAlignment.Center
            namelabel.font = UIFont.systemFontOfSize(30)
            namelabel.textColor = Constants.TEXTCOLOR
            self.view.addSubview(namelabel)
        }
        
        fitAccount()
    }
    
    func fitAccount() {
        let account = ModelManager.manager.getAccount()
        imageView.image = account.getImage()
        namelabel.text = account.getTwitterId()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}