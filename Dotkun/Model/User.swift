//
//  User.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class User {
    // DBから取得, autoIncrement
    private var userId: String! = nil
    
    private var image: UIImage? = UIImage(named: "ha1f.png")
    
    // twitterAccount
    private var twitterId: String! = "_ha1f"
    
    // スクリーンネーム
    private var userName: String = "はるふ"
    
    func isLoggedIn() -> Bool {
        return !(twitterId == nil)
    }
    
    func getImage() -> UIImage? {
        return self.image
    }
    
    func getTwitterId() -> String! {
        return self.twitterId
    }
}
