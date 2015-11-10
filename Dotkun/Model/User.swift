//
//  User.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit
import TwitterKit

class User {
    // DBから取得, autoIncrement
    private var userId: String! = nil
    
    private var image: UIImage? = nil
    
    // twitterAccount
    private var twitterId: String? = nil
    private var twitterUserId: String? = ""
    var profileImageUrl: String? = nil
    
    // 表示する名前
    private var userName: String = ""
    
    init(tUser: TWTRUser) {
        self.twitterId = tUser.screenName
        self.twitterUserId = tUser.userID
        self.userName = tUser.name
        self.profileImageUrl = tUser.profileImageURL
    }
    
    func isLoggedIn() -> Bool {
        return !(twitterId == nil)
    }
    
    func getImage() -> UIImage? {
        return self.image
    }
    
    func getTwitterId() -> String! {
        return self.twitterId
    }
    
    func getTwitterUserId() -> String! {
        return self.twitterUserId
    }
}
