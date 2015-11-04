//
//  BattleIcon.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/04.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit
import RealmSwift

class BattleIcon: Object {
    static let realm = try! Realm()
    
    dynamic private var id = 0
    
    dynamic private var _image: UIImage?
    dynamic var image: UIImage? {
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    dynamic private var imageData: NSData?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
    
    static func new(image: UIImage?) -> BattleIcon {
        let icon = BattleIcon()
        icon.image = image!
        icon.id = lastId()
        try! realm.write {
            realm.add(icon, update: true)
        }
        return icon
    }
    
    static func loadAll() -> [BattleIcon] {
        let battleIcons = realm.objects(BattleIcon).sorted("id", ascending: false)
        var ret: [BattleIcon] = []
        for battleIcon in battleIcons {
            ret.append(battleIcon)
        }
        return ret
    }
    
    static func lastId() -> Int {
        if let user = realm.objects(BattleIcon).last {
            return user.id + 1
        } else {
            return 1
        }
    }
}
