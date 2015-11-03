//
//  User.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

class User {
    // DBから取得, autoIncrement
    private var userId: String! = nil
    
    // twitterAccount
    private var twitterId: String! = nil
    
    // スクリーンネーム
    private var userName: String = ""
    
    func isLoggedIn() -> Bool {
        return !(twitterId == nil)
    }
}
