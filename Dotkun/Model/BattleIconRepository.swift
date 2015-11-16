//
//  BattleIconRepository.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/08.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit
import RealmSwift

class BattleIconRepository {
    
    private var battleIcons: [BattleIcon] = []
    private var isLoading: Bool = false
    
    func reload() {
        if isLoading {
            return
        }
        isLoading = true
        
        let realm = BattleIcon.realm
        
        if let lastId = self.battleIcons.first?.id {
            // 新しいデータのみロード、古い順に前に追加
            let loadedData = realm.objects(BattleIcon).filter("twitterUserId == '\(ModelManager.manager.getAccount().getTwitterUserId())'").filter("id > \(lastId)").sorted("id", ascending: true)
            for battleIcon in loadedData {
                self.battleIcons.insert(battleIcon, atIndex: 0)
            }
        } else {
            // はじめだけ、新しい順にすべてのデータをロード
            let loadedData = realm.objects(BattleIcon).filter("twitterUserId == '\(ModelManager.manager.getAccount().getTwitterUserId())'").sorted("id", ascending: false)
            for battleIcon in loadedData {
                self.battleIcons.append(battleIcon)
            }
        }
        
        isLoading = false
    }
    
    func getById(id: Int) -> BattleIcon? {
        if self.battleIcons.isEmpty {
            self.reload()
        }
        for i in self.battleIcons {
            if i.id == id {
                return i
            }
        }
        return nil
    }
    
    func getAll() -> [BattleIcon] {
        if self.battleIcons.isEmpty {
            self.reload()
        }
        return self.battleIcons
    }
    
    func get(index: Int) -> BattleIcon! {
        if self.battleIcons.isEmpty {
            self.reload()
        }
        while isLoading {}
        if self.battleIcons.count > index {
            return self.battleIcons[index]
        } else {
            return nil
        }
    }
    func getBattleIconCount() -> Int {
        return self.battleIcons.count
    }
}