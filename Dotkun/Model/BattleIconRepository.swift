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
    
    func reload() {
        let realm = BattleIcon.realm
        
        if let lastId = self.battleIcons.first?.id {
            // 新しいデータのみロード、古い順に前に追加
            let loadedData = realm.objects(BattleIcon).filter("id > \(lastId)").sorted("id", ascending: true)
            for battleIcon in loadedData {
                self.battleIcons.insert(battleIcon, atIndex: 0)
            }
        } else {
            // はじめだけ、新しい順にすべてのデータをロード
            let loadedData = realm.objects(BattleIcon).sorted("id", ascending: false)
            for battleIcon in loadedData {
                self.battleIcons.append(battleIcon)
            }
        }
    }
    
    func getAll() -> [BattleIcon] {
        self.reload()
        return self.battleIcons
    }
    
    func get(index: Int) -> BattleIcon {
        return self.battleIcons[index]
    }
    func getBattleIconCount() -> Int {
        return self.battleIcons.count
    }
}