//
//  ModelManager.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import Foundation

class ModelManager {
    static let manager = ModelManager()
    
    private var account: User! = nil
    func getAccount() -> User! {
        return self.account
    }
    func setAccount(user: User) {
        self.account = user
    }
}